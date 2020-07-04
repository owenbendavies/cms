import RichTextInput from 'ra-input-rich-text';
import React from 'react';
import { BooleanInput, SimpleForm, TextInput } from 'react-admin';

const configureQuill = (quill) =>
  quill.scrollingContainer.classList.add('main');

const pageToolbar = [
  [
    { header: [2, 3, false] },
    'bold',
    'italic',
    { script: 'sub' },
    { script: 'super' },
  ],
  [{ list: 'bullet' }, { list: 'ordered' }],
  ['link'],
  ['clean'],
];

export const PageForm = (props) => (
  <SimpleForm {...props}>
    <TextInput disabled source="url" />
    <TextInput source="name" />
    <BooleanInput source="private" />
    <BooleanInput source="contactForm" />
    <RichTextInput
      source="htmlContent"
      configureQuill={configureQuill}
      toolbar={pageToolbar}
    />
  </SimpleForm>
);
