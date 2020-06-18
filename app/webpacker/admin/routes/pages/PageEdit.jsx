import React from 'react';

import RichTextInput from 'ra-input-rich-text';

import { BooleanInput, Edit, SimpleForm, TextInput } from 'react-admin';

const configureQuill = (quill) =>
  quill.scrollingContainer.classList.add('main');

const PageTitle = ({ record }) => <span>{`Page ${record.name}`}</span>;

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

export const PageEdit = (props) => (
  <Edit title={<PageTitle />} {...props}>
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
  </Edit>
);
