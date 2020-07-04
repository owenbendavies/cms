import tinymce from 'tinymce';
import skin from 'tinymce-light-skin';
import 'tinymce/plugins/autolink';
import 'tinymce/plugins/link';
import 'tinymce/plugins/lists';
import 'tinymce/plugins/paste';
import 'tinymce/themes/modern/theme';

skin.use();

tinymce.init({
  block_formats: 'Main Header=h2;Sub Header=h3;Paragraph=p',
  browser_spellcheck: true,
  element_format: 'html',
  entity_encoding: 'raw',
  inline: true,
  menubar: false,
  plugins: 'autolink,link,lists,paste',
  selector: '.js-tinymce',
  skin: false,
  toolbar:
    'formatselect bold italic subscript superscript | bullist numlist | link',
});
