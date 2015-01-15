//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require jquery.autogrowtextarea
//= require rails-timeago
//= require twitter/bootstrap/rails/confirm
//= require turbolinks
//= require google-analytics-turbolinks
//= require_tree .

$(document).ready(function() {
    $('textarea.autogrow').autoGrow();
});

Turbolinks.enableProgressBar();
