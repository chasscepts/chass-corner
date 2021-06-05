const init_fb = () => {
  if (typeof FB !== 'undefined') {
    FB.XFBML.parse();
    return;
  }
  window.fbAsyncInit = function(){
    FB.XFBML.parse();
  };
}

document.addEventListener('turbolinks:load', init_fb);
