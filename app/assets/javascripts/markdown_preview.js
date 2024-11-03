function debounce(func, timeout = 300){
  let timer;
  return (...args) =>{
    clearTimeout(timer);
    timer = setTimeout(() => {func.apply(this, args); }, timeout);
  };
}

//---POST METHOD OF GENERATING LIVE PREVIEW (DOES NOT WORK ON DEPLOYED APP)---
//document.addEventListener('DOMContentLoaded', function() {
  //const markdownInput = document.getElementById('markdownBody');
  //const previewArea = document.getElementById('markdownPreview');

  //const path = window.location.pathname.split('/');

  //let projectID = null;

  // Check if this is for a new project or an existing project being edited.
  //if (!path.includes('new')) {
  //  projectID = path[2];
  //}

  // This is responsible for sending input to be converted, then outputting that as a preview.
  //function updatePreview() {
  //  const url = projectID ? `/projects/${projectID}/preview` : `/projects/new`;

    //fetch(url, {
    //  method: 'POST',
    //  headers: {
    //    'Content-Type': 'application/json',
    //    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    //  },
    //  body: JSON.stringify({ data: markdownInput.value })
    //})
    //.then(response => response.json())
    //.then(data => {
    //  previewArea.innerHTML = data.result;
    //})
    //.catch(error => console.error('Error:', error));
  //}

  //const debouncedUpdatePreview = debounce(updatePreview, 300);

  // Run updatePreview once on page load
  //updatePreview();

  // Whenever an input is receivd, run updatePreview, but with the debouncer to limit requests.
  //markdownInput.addEventListener('input', debouncedUpdatePreview);

//});

//--- MARKED.JS CDN METHOD OF GENERATING LIVE PREVIEW ---
document.getElementById('markdownBody').addEventListener('input', function(){
  const markdownInput = this.value;
  const markdown = marked.parse(markdownInput);
  document.getElementById('markdownPreview').innerHTML = markdown;
});
