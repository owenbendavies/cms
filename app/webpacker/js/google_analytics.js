/* global ga */

document.addEventListener("turbolinks:load", function() {
  "use strict";

  if(typeof ga !== "undefined") {
    ga("send", "pageview", window.location.pathname);
  }
});
