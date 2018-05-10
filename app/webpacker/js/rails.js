import $ from "jquery";
import "timeago";

document.addEventListener("turbolinks:load", function() {
  "use strict";

  $(".js-timeago").timeago();
});
