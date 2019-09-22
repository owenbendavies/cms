import React from 'react';

import {
  BooleanInput,
  DisabledInput,
  Edit,
  SimpleForm,
  TextInput,
} from 'react-admin';

const PageTitle = ({ record }) => <span>{`Page ${record.name}`}</span>;

export const PageEdit = props => (
  <Edit title={<PageTitle />} {...props}>
    <SimpleForm>
      <DisabledInput source="url" />
      <TextInput source="name" />
      <BooleanInput source="private" />
      <BooleanInput source="contactForm" />
    </SimpleForm>
  </Edit>
);
