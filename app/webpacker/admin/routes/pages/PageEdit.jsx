import RichTextInput from 'ra-input-rich-text';
import React from 'react';
import { BooleanInput, Edit, SimpleForm, TextInput } from 'react-admin';
import { pageToolbar } from './PageForm';

const PageTitle = ({ record }) => <span>{`Page ${record.name}`}</span>;

const configureQuill = (quill) =>
  quill.scrollingContainer.classList.add('main');

export const PageEdit = (props) => (
  <Edit title={<PageTitle />} undoable={false} {...props}>
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
