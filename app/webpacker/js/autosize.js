import autosize from 'autosize';
import $ from 'jquery';

document.addEventListener('turbolinks:load', () => {
  autosize($('.js-autogrow'));
});
