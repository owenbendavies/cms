$(document).on("turbolinks:load", function() {
  "use strict";

  if(typeof ga !== "undefined") {
    ga("send", "pageview", window.location.pathname);
  }
});
