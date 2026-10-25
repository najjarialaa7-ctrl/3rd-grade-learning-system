/* Shared test helpers. The runner (scripts/run-tests.ps1) loads this file, sample.js (the sample snapshot)
   and one *.test.html in front of the app page, opens it in headless Edge and reads data-result. */
try{localStorage.clear()}catch(e){}
window.__errs=[];
window.addEventListener('error',e=>{window.__errs.push(String(e.message)+' @'+e.lineno)});

/* Speech: a fake engine that "speaks" instantly and records what was said and with which voice. */
window.__said=[];
window.__voices=[];
window.SpeechSynthesisUtterance=function(t){this.text=t;this.voice=null;this.rate=1;this.lang=''};
Object.defineProperty(window,'speechSynthesis',{configurable:true,value:{
  speak(u){window.__said.push({voice:u.voice&&u.voice.name,rate:u.rate,text:u.text});setTimeout(()=>{u.onstart&&u.onstart();setTimeout(()=>u.onend&&u.onend(),5)},5)},
  cancel(){},resume(){},getVoices(){return window.__voices},speaking:false,pending:false,addEventListener(){}}});

/* A fake Claude runtime: an in-memory database built from a snapshot, plus a signed-in owner. */
window.fakeClaude=function(snap,opts){
  opts=opts||{};
  const data={weeks:(snap.weeks||[]).slice(),lessons:(snap.lessons||[]).slice(),items:(snap.items||[]).slice(),results:[]};
  const settings=Object.assign({nexUrl:snap.nexUrl||'',tables:snap.tables,student:snap.student},opts.settings||{});
  const writes=window.__writes=[];
  const qs=arr=>({docs:arr.map(d=>({id:d.id,exists:true,data:()=>d})),size:arr.length,empty:!arr.length});
  let n=0;
  const db={collection:c=>({onSnapshot:cb=>{setTimeout(()=>cb(qs(data[c]||[])),10);return()=>{}},
      add:async v=>{const id='new'+(++n);writes.push([c+'/'+id,v]);return{id}}}),
    doc:p=>({onSnapshot:cb=>{setTimeout(()=>cb(p==='settings/main'?{exists:true,data:()=>settings}:{exists:false,data:()=>undefined}),10);return()=>{}},
      set:async v=>{writes.push([p,v])},update:async v=>{writes.push([p,v])}})};
  const caps={db,user:{can:async()=>true,canEdit:async()=>true}};
  if(opts.publish)caps.artifact={publish:async html=>{window.__published=html;return{version:'test'}}};
  /* opts.sample: the JSON a fake Claude returns; the images it was sent are kept in window.__sampled */
  if(opts.sample)caps.sample={json:async(prompt,o)=>{window.__sampled=(o&&o.images)||[];return opts.sample},limits:async()=>({images:{maxCount:5}})};
  /* opts.files: { fileId: Blob } served at /_blob/<id>, like the artifact's file storage */
  if(opts.files){const real=window.fetch.bind(window);window.fetch=(u,o)=>{const m=/^\/_blob\/(.+)$/.exec(String(u));if(m&&opts.files[m[1]])return Promise.resolve(new Response(opts.files[m[1]]));return real(u,o)}}
  window.claude={use:async n=>caps[n]||null};
};

/* Assertions and helpers */
window.T_={fails:[],
  ok(cond,msg){if(!cond)this.fails.push(msg)},
  done(){
    if(window.__errs.length)this.fails.push('JS errors: '+window.__errs.join(' | '));
    document.documentElement.setAttribute('data-result',this.fails.length?'FAIL: '+this.fails.join('; '):'PASS');
  }};
window.$q=s=>document.querySelector(s);
window.$qa=s=>[...document.querySelectorAll(s)];
window.$txt=s=>{const e=document.querySelector(s);return e?e.textContent.replace(/\s+/g,' ').trim():''};
window.wait=ms=>new Promise(r=>setTimeout(r,ms));
window.runTest=fn=>setTimeout(async()=>{try{await fn()}catch(e){T_.fails.push('stopped: '+(e&&e.message||e))}T_.done()},1000);
