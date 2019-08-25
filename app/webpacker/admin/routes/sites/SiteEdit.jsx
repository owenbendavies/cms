import React from 'react';

import {
  BooleanInput,
  DisabledInput,
  Edit,
  FormTab,
  LongTextInput,
  SaveButton,
  TabbedForm,
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
    <TabbedForm toolbar={<SiteToolbar />}>
      <FormTab label="Settings">
        <DisabledInput source="address" />
        <DisabledInput source="email" />
        <TextInput source="name" />
        <TextInput source="googleAnalytics" />
        <TextInput source="charityNumber" />
        <BooleanInput source="separateHeader" />
        <BooleanInput source="mainMenuInFooter" />
      </FormTab>
      <FormTab label="CSS">
        <LongTextInput source="css" />
      </FormTab>
    </TabbedForm>
  </Edit>
);
