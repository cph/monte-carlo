// Source: https://gist.github.com/ugin/5779160

function domReady(f) { /in/.test(document.readyState) ? setTimeout(domReady,16,f) : f() }

function resize(textarea) {
  textarea.style.height = 'auto';
  textarea.style.height = textarea.scrollHeight+'px';
}

/* 0-timeout to get the already changed text */
function delayedResize(event) {
  window.setTimeout(resize, 0, event.target);
}

domReady(function () {
  var textareas = document.querySelectorAll('textarea');

  for (var i = 0, l = textareas.length; i < l; ++i) {
    var el = textareas.item(i);

    el.addEventListener('change',  resize, false);
    el.addEventListener('cut',     delayedResize, false);
    el.addEventListener('paste',   delayedResize, false);
    el.addEventListener('drop',    delayedResize, false);
    el.addEventListener('keydown', delayedResize, false);

    resize(el);
  }
});
