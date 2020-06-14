import React from 'react';

import RichTextInput from 'ra-input-rich-text';

import {
  BooleanInput,
  Edit,
  FormTab,
  TabbedForm,
  TextInput,
} from 'react-admin';

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
    <TabbedForm>
      <FormTab label="content">
        <RichTextInput source="htmlContent" toolbar={pageToolbar} />
      </FormTab>
      <FormTab label="Settings">
        <TextInput disabled source="url" />
        <TextInput source="name" />
        <BooleanInput source="private" />
        <BooleanInput source="contactForm" />
      </FormTab>
    </TabbedForm>
  </Edit>
);
