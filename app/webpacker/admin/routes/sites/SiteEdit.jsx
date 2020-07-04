import React from 'react';
import {
  BooleanInput,
  Edit,
  FormTab,
  SaveButton,
  TabbedForm,
  TextInput,
  Toolbar,
} from 'react-admin';

const SiteTitle = ({ record }) => <span>{`Site ${record.name}`}</span>;

const SiteToolbar = (props) => (
  <Toolbar {...props}>
    <SaveButton />
  </Toolbar>
);

export const SiteEdit = (props) => (
  <Edit title={<SiteTitle />} {...props}>
    <TabbedForm toolbar={<SiteToolbar />}>
      <FormTab label="Settings">
        <TextInput disabled source="address" />
        <TextInput disabled source="email" />
        <TextInput source="name" />
        <TextInput source="googleAnalytics" />
        <TextInput source="charityNumber" />
        <BooleanInput source="separateHeader" />
        <BooleanInput source="mainMenuInFooter" />
      </FormTab>
      <FormTab label="CSS">
        <TextInput fullWidth multiline source="css" />
      </FormTab>
    </TabbedForm>
  </Edit>
);
