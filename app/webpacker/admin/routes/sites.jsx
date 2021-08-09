import SiteIcon from '@material-ui/icons/Language';
import gql from 'graphql-tag';
import React from 'react';
import {
  BooleanInput,
  Datagrid,
  Edit,
  EmailField,
  FormTab,
  List,
  Responsive,
  SaveButton,
  SimpleList,
  TabbedForm,
  TextField,
  TextInput,
  Toolbar,
  UrlField,
} from 'react-admin';

export const sitesQueries = {
  GET_LIST: gql`
    query Sites($first: Int, $after: String) {
      sites(first: $first, after: $after) {
        nodes {
          id
          address
          name
          email
          googleAnalytics
          charityNumber
        }
        totalCount
      }
    }
  `,
  GET_ONE: gql`
    query Node($id: ID!) {
      node(id: $id) {
        id
        ... on Site {
          address
          email
          name
          googleAnalytics
          charityNumber
          mainMenuInFooter
          separateHeader
          css
        }
      }
    }
  `,
};

const SiteTitle = ({ record }) => <span>{`Site ${record.name}`}</span>;

const SiteToolbar = (props) => (
  <Toolbar {...props}>
    <SaveButton />
  </Toolbar>
);

const SiteEdit = (props) => (
  <Edit title={<SiteTitle />} mutationMode="pessimistic" {...props}>
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

const SiteList = (props) => (
  <List bulkActionButtons={false} {...props}>
    <Responsive
      small={
        <SimpleList
          primaryText={(record) => record.name}
          secondaryText={(record) => record.address}
          linkType="edit"
        />
      }
      medium={
        <Datagrid rowClick="edit">
          <TextField source="name" sortable={false} />
          <UrlField source="address" sortable={false} />
          <EmailField source="email" sortable={false} />
          <TextField source="googleAnalytics" sortable={false} />
          <TextField source="charityNumber" sortable={false} />
        </Datagrid>
      }
    />
  </List>
);

export const siteOptions = {
  edit: SiteEdit,
  icon: SiteIcon,
  list: SiteList,
  name: 'sites',
};
