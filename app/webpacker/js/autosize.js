import $ from 'jquery';
import autosize from 'autosize';

document.addEventListener('turbolinks:load', () => {
  autosize($('.js-autogrow'));
});
