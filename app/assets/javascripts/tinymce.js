$(document).ready(function() {
  tinyMCE.init({
    'block_formats': 'Main Header=h2;Sub Header=h3;Paragraph=p;Code=pre',
    'browser_spellcheck': true,
    'inline': true,
    'menubar': false,
    'plugins': 'autolink link code table paste',
    'selector': 'div.tinymce',
    'toolbar': 'formatselect bold italic strikethrough subscript superscript | bullist numlist | link | table | code',
    'visual_table_class': 'table table-bordered'
  });
});
