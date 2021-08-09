import PageIcon from '@material-ui/icons/Subject';
import gql from 'graphql-tag';
import RichTextInput from 'ra-input-rich-text';
import React from 'react';
import {
  BooleanField,
  BooleanInput,
  BulkDeleteButton,
  Create,
  Datagrid,
  Edit,
  List,
  Responsive,
  SimpleForm,
  SimpleList,
  TextField,
  TextInput,
} from 'react-admin';

export const pagesQueries = {
  GET_LIST: gql`
    query Pages($first: Int, $after: String) {
      pages(first: $first, after: $after) {
        nodes {
          id
          name
          private
          contactForm
        }
        totalCount
      }
    }
  `,
  GET_ONE: gql`
    query Node($id: ID!) {
      node(id: $id) {
        id
        ... on Page {
          contactForm
          htmlContent
          name
          private
          url
        }
      }
    }
  `,
};

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

export const PageCreate = (props) => (
  <Create {...props}>
    <PageForm />
  </Create>
);

const PageTitle = ({ record }) => <span>{`Page ${record.name}`}</span>;

export const PageEdit = (props) => (
  <Edit title={<PageTitle />} mutationMode="pessimistic" {...props}>
    <PageForm />
  </Edit>
);

const PageBulkActions = (props) => (
  <BulkDeleteButton undoable={false} {...props} />
);

export const PageList = (props) => (
  <List bulkActionButtons={<PageBulkActions />} {...props}>
    <Responsive
      small={
        <SimpleList primaryText={(record) => record.name} linkType="edit" />
      }
      medium={
        <Datagrid rowClick="edit">
          <TextField source="name" sortable={false} />
          <BooleanField source="private" sortable={false} />
          <BooleanField source="contactForm" sortable={false} />
        </Datagrid>
      }
    />
  </List>
);

export const pageOptions = {
  create: PageCreate,
  edit: PageEdit,
  icon: PageIcon,
  list: PageList,
  name: 'pages',
};
