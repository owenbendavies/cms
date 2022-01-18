import $ from 'jquery';
import 'timeago';

document.addEventListener('turbolinks:load', () => {
  $('.js-timeago').timeago();
});
