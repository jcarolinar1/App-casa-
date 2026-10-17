/* Casa en Orden 3.4 – modo sin conexión, sin borrar cachés de otros repositorios */
'use strict';
const PATH=new URL(self.registration.scope).pathname.replace(/[^a-z0-9]+/gi,'-');
const PREFIX='casa-en-orden-'+PATH+'-';
const CACHE=PREFIX+'app-v34';
const LIB_CACHE=PREFIX+'bibliotecas-v34';
const ASSETS=['./','./index.html','./styles.css?v=3.4','./app.js?v=3.4','./ocr.js?v=3.4','./manifest.webmanifest','./icon-180.png','./icon-192.png','./icon-512.png'];
const assetURLs=ASSETS.map(s=>new URL(s,self.registration.scope).href);
async function precache(){const cache=await caches.open(CACHE);await cache.addAll(assetURLs);}
self.addEventListener('install',event=>{event.waitUntil(precache().then(()=>self.skipWaiting()));});
self.addEventListener('activate',event=>{event.waitUntil((async()=>{
 const names=await caches.keys();await Promise.all(names.filter(n=>n.startsWith(PREFIX)&&n!==CACHE&&n!==LIB_CACHE).map(n=>caches.delete(n)));
 await self.clients.claim();
})());});
self.addEventListener('message',event=>{
 if(event.data?.type!=='PREPARE_OFFLINE')return;
 event.waitUntil(precache().then(()=>event.ports[0]?.postMessage({ok:true})).catch(err=>event.ports[0]?.postMessage({ok:false,error:String(err.message||err)})));
});
self.addEventListener('fetch',event=>{
 const req=event.request;if(req.method!=='GET')return;
 const url=new URL(req.url);const same=url.origin===self.location.origin;
 if(!same){
  // Caché opcional para motores externos ya descargados. No publica archivos privados.
  if(url.protocol!=='https:'||!['cdn.jsdelivr.net','unpkg.com','tessdata.projectnaptha.com'].includes(url.hostname))return;
  event.respondWith((async()=>{const cache=await caches.open(LIB_CACHE);const hit=await cache.match(req);if(hit)return hit;const res=await fetch(req);if(res.ok||res.type==='opaque')await cache.put(req,res.clone()).catch(()=>{});return res})());return;
 }
 // Nunca interceptar URL fuera de este repositorio/scope.
 if(!url.pathname.startsWith(new URL(self.registration.scope).pathname))return;
 if(req.mode==='navigate'){
  event.respondWith((async()=>{try{const res=await fetch(req);if(res.ok){const cache=await caches.open(CACHE);await cache.put(new URL('./index.html',self.registration.scope),res.clone());return res}}catch{}
   const cached=await caches.match(new URL('./index.html',self.registration.scope));return cached||Response.error();})());return;
 }
 event.respondWith((async()=>{const hit=await caches.match(req);if(hit)return hit;try{const res=await fetch(req);if(res.ok){const cache=await caches.open(CACHE);await cache.put(req,res.clone()).catch(()=>{})}return res}catch{return Response.error()}})());
});
