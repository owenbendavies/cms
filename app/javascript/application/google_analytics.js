/* global ga */

document.addEventListener('turbolinks:load', () => {
  if (typeof ga !== 'undefined') {
    ga('send', 'pageview', window.location.pathname);
  }
});
