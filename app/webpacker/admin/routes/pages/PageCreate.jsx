import RichTextInput from 'ra-input-rich-text';
import React from 'react';
import { BooleanInput, Create, SimpleForm, TextInput } from 'react-admin';
import { pageToolbar } from './PageForm';

const configureQuill = (quill) =>
  quill.scrollingContainer.classList.add('main');

export const PageCreate = (props) => (
  <Create {...props}>
    <SimpleForm>
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
  </Create>
);
