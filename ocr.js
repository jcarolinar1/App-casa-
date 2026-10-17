/* Casa en Orden 3.3 - lectura local y asistida de comprobantes (OCR) */
(function(root){'use strict';
const clean=s=>String(s||'').trim().replace(/\s+/g,' ');
const normalized=s=>clean(s).toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g,'');
const scriptURL='https://cdn.jsdelivr.net/npm/tesseract.js@5.1.1/dist/tesseract.min.js';
let loader=null;
function loadEngine(){
 if(root.Tesseract?.createWorker)return Promise.resolve(root.Tesseract);
 if(!loader)loader=new Promise((resolve,reject)=>{
  const script=document.createElement('script');script.src=scriptURL;script.async=true;
  script.onload=()=>root.Tesseract?.createWorker?resolve(root.Tesseract):reject(Error('El lector no pudo iniciarse.'));
  script.onerror=()=>reject(Error('No se pudo descargar el lector de texto. Revisa tu conexión.'));
  document.head.appendChild(script);
 }).catch(e=>{loader=null;throw e});
 return loader;
}
function extractMoney(segment){
 // COP with thousands separators or decimal cents (e.g. 125.500 / 125500 / 125.500,00).
 const tokens=String(segment||'').match(/\$?\s*(?:\d{1,3}(?:[.\s,]\d{3})+(?:[.,]\d{2})?|\d{4,10}(?:[.,]\d{2})?|\d{1,3}[.,]\d{2})/g)||[];
 return tokens.map(s=>{
  let t=s.replace(/[^0-9,.]/g,'');if(!t)return null;
  if(/[.,]\d{2}$/.test(t)&&t.length>3)t=t.slice(0,-3).replace(/[.,]/g,'')+'.'+t.slice(-2);
  else t=t.replace(/[.,]/g,'');
  const v=Math.round(Number(t));return v>=100&&v<=100000000? v:null;
 }).filter(v=>v!==null);
}
function getAmount(lines){
 const direct=[];
 for(let i=0;i<lines.length;i++){
  let n=normalized(lines[i]);
  if(/subtotal|sub\s*total|iva|impuesto|descuento|cambio|devolucion|vuelto|propina|efectivo recibido|numero|nit|factura no|autorizacion/.test(n))continue;
  let rank=0;
  if(/(?:total\s*(?:a\s*pagar|pagado|compra|venta)?|valor\s*(?:pagado|total|a\s*pagar)|importe\s*total|neto\s*a\s*pagar|monto\s*total)/.test(n))rank=4;
  else if(/(?:valor\s*de\s*la\s*transaccion|monto\s*de\s*la\s*transaccion|transferencia\s*por|valor\s*enviado|valor\s*recibido|valor\s*transferido)/.test(n))rank=3;
  else if(/(?:pagado|pago|transferido|recibiste|enviaste)/.test(n))rank=1;
  if(!rank)continue;
  const amounts=extractMoney(lines[i]);
  // If the label stands alone, a number may be immediately below it.
  if(!amounts.length && i+1<lines.length)amounts.push(...extractMoney(lines[i+1]));
  if(amounts.length)direct.push({v:amounts[amounts.length-1],rank,idx:i});
 }
 if(direct.length){direct.sort((a,b)=>b.rank-a.rank||b.idx-a.idx);return direct[0].v;}
 // Only use an unlabelled amount if there is exactly one plausible currency amount.
 const marked=lines.filter(x=>x.includes('$')).flatMap(extractMoney);
 return marked.length===1?marked[0]:null;
}
function getDate(lines){
 const text=lines.join(' ');
 let match;
 const re=/(?:^|\D)(\d{1,2})[\/.-](\d{1,2})[\/.-](20\d{2})(?!\d)/g;
 const iso=/(?:^|\D)(20\d{2})[\/.-](\d{1,2})[\/.-](\d{1,2})(?!\d)/g;
 const all=[];
 while((match=re.exec(text)))all.push([Number(match[3]),Number(match[2]),Number(match[1])]);
 while((match=iso.exec(text)))all.push([Number(match[1]),Number(match[2]),Number(match[3])]);
 for(const [year,month,day] of all){
  let d=new Date(year,month-1,day);
  if(d.getFullYear()===year&&d.getMonth()===month-1&&d.getDate()===day&&year>=2020&&d.getTime()<=Date.now()+86400000){
   return `${year}-${String(month).padStart(2,'0')}-${String(day).padStart(2,'0')}`;
  }
 }
 return null;
}
function getMethod(text){
 const t=normalized(text);
 if(/\bnequi\b/.test(t))return 'Nequi';
 if(/\bdaviplata\b/.test(t))return 'Daviplata';
 if(/\bpse\b/.test(t))return 'PSE';
 if(/tarjeta\s*credito|credito\s*visa|mastercard\s*credito/.test(t))return 'Tarjeta crédito';
 if(/tarjeta\s*debito|debito\s*visa/.test(t))return 'Tarjeta débito';
 if(/transferencia|transferiste|transferido|transferencia exitosa/.test(t))return 'Transferencia bancaria';
 if(/\befectivo\b/.test(t))return 'Efectivo';
 return null;
}
function getMerchant(lines){
 const invalid=/^(?:factura|recibo|comprobante|nit\b|fecha\b|hora\b|cajero|cliente|tel[efono]*\b|www\.|http|direccion|dir\.|subtotal|sub\s*total|descuento|cambio|total|valor|iva|impuesto|cuenta|transaccion|transferencia|nequi\b|daviplata\b|pse\b|bancolombia\b|pago|autorizacion|documento|cop\b|$)/i;
 const candidates=lines.slice(0,7).map(clean).filter(x=>x.length>=4&&x.length<=65&&!invalid.test(normalized(x))&&!/^[-\d\s.$:;/#]+$/.test(x)&&/[a-zA-Záéíóúñ]/.test(x)&&!x.includes('@'));
 return candidates.find(x=>!/^\d{1,2}\s+(?:ene|feb|mar|abr|may|jun|jul|ago|sep|oct|nov|dic)\w*\s+20\d{2}/i.test(normalized(x))&&!/^(?:20\d{2}[\/-]\d{1,2}[\/-]\d{1,2}|\d{1,2}[\/-]\d{1,2}[\/-]20\d{2})/.test(x))||null;
}
function getCategory(text){
 const s=normalized(text);
 if(/mercado|supermercado|exito\b|d1\b|ara\b|almacen|supertienda/.test(s))return 'Mercado';
 if(/internet|energia|acueducto|gas natural|servicio publico|telefonia|movistar|claro\b|tigo\b/.test(s))return 'Servicios';
 if(/farmacia|drogueria|medicamento|salud/.test(s))return 'Salud';
 if(/gasolina|combustible|estacion de servicio|peaje/.test(s))return 'Transporte';
 if(/restaurante|domicilio|comida|almuerzo|pizza/.test(s))return 'Alimentación';
 return null;
}
function parse(text){
 const lines=String(text||'').split(/\r?\n/).map(clean).filter(Boolean);
 const amount=getAmount(lines),date=getDate(lines),method=getMethod(text),merchant=getMerchant(lines),category=getCategory(text);
 return {amount,date,method,name:merchant,category};
}
async function scan(file,onProgress=()=>{}){
 if(!file||!/^image\//.test(file.type))throw Error('Para autocompletar selecciona una fotografía (JPG, PNG, HEIC o WebP).');
 if(file.size>4*1024*1024)throw Error('La fotografía supera 4 MB. Usa una más pequeña.');
 onProgress('Cargando lector de texto (requiere internet la primera vez)…');
 const tess=await loadEngine();
 let worker;
 try{
  worker=await tess.createWorker('spa',1,{logger:msg=>{
   if(msg.status==='recognizing text'&&Number.isFinite(msg.progress))onProgress(`Leyendo la foto… ${Math.round(msg.progress*100)} %`);
  }});
  const result=await worker.recognize(file);
  const text=result?.data?.text||'';
  if(!text.trim())throw Error('No se pudo leer texto en esta foto. Prueba una imagen más nítida.');
  return parse(text);
 }finally{if(worker)await worker.terminate().catch(()=>{});}
}
async function prepare(){
 const tess=await loadEngine();let worker;
 try{worker=await tess.createWorker('spa',1);return true}finally{if(worker)await worker.terminate().catch(()=>{});}
}
root.CasaOCR={parse,scan,prepare};
})(window);
