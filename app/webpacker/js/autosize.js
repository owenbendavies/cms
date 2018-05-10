import $ from "jquery";
import autosize from "autosize";

document.addEventListener("turbolinks:load", function() {
  "use strict";

  autosize($(".js-autogrow"));
});
