import MessageIcon from '@material-ui/icons/Email';
import gql from 'graphql-tag';
import React from 'react';
import {
  BulkDeleteButton,
  Datagrid,
  DateField,
  DeleteButton,
  EmailField,
  List,
  Responsive,
  RichTextField,
  Show,
  SimpleList,
  SimpleShowLayout,
  TextField,
  TopToolbar,
} from 'react-admin';

export const messagesQueries = {
  GET_LIST: gql`
    query Messages($first: Int, $after: String, $orderBy: MessageOrder!) {
      messages(first: $first, after: $after, orderBy: $orderBy) {
        nodes {
          id
          name
          email
          phone
          createdAt
        }
        totalCount
      }
    }
  `,
  GET_ONE: gql`
    query Node($id: ID!) {
      node(id: $id) {
        id
        ... on Message {
          name
          email
          phone
          createdAt
          message
        }
      }
    }
  `,
};

const MessageBulkActions = (props) => (
  <BulkDeleteButton undoable={false} {...props} />
);

const MessageList = (props) => (
  <List
    bulkActionButtons={<MessageBulkActions />}
    sort={{ field: 'createdAt', order: 'DESC' }}
    {...props}
  >
    <Responsive
      small={
        <SimpleList
          primaryText={(record) => record.name}
          secondaryText={(record) => record.email}
          tertiaryText={(record) =>
            new Date(record.createdAt).toLocaleDateString()
          }
          linkType="show"
        />
      }
      medium={
        <Datagrid rowClick="show">
          <TextField source="name" />
          <EmailField source="email" />
          <TextField source="phone" />
          <DateField source="createdAt" showTime />
        </Datagrid>
      }
    />
  </List>
);

const MessageTitle = ({ record }) => (
  <span>{`Message from ${record.name}`}</span>
);

const MessageShowActions = ({ basePath, data, resource }) => (
  <TopToolbar>
    <DeleteButton
      mutationMode="pessimistic"
      basePath={basePath}
      record={data}
      resource={resource}
    />
  </TopToolbar>
);

const MessageShow = (props) => (
  <Show title={<MessageTitle />} actions={<MessageShowActions />} {...props}>
    <SimpleShowLayout>
      <TextField source="name" />
      <EmailField source="email" />
      <TextField source="phone" />
      <DateField source="createdAt" showTime />
      <RichTextField source="message" />
    </SimpleShowLayout>
  </Show>
);

export const messageOptions = {
  icon: MessageIcon,
  list: MessageList,
  name: 'messages',
  show: MessageShow,
};
