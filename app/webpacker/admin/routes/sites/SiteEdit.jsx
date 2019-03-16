import React from 'react';

import {
  BooleanInput,
  DisabledInput,
  Edit,
  SaveButton,
  SimpleForm,
  TextInput,
  Toolbar,
} from 'react-admin';

const SiteTitle = ({ record }) => <span>{`Site ${record.name}`}</span>;

const SiteToolbar = props => (
  <Toolbar {...props}>
    <SaveButton />
  </Toolbar>
);

export const SiteEdit = props => (
  <Edit title={<SiteTitle />} {...props}>
    <SimpleForm toolbar={<SiteToolbar />}>
      <DisabledInput source="address" />
      <DisabledInput source="email" />
      <TextInput source="name" />
      <TextInput source="googleAnalytics" />
      <TextInput source="charityNumber" />
      <BooleanInput source="separateHeader" />
      <BooleanInput source="mainMenuInFooter" />
    </SimpleForm>
  </Edit>
);
