import gql from 'graphql-tag';
import React from 'react';

import {
  CardActions,
  Datagrid,
  DateField,
  DeleteButton,
  List,
  ListButton,
  Responsive,
  RichTextField,
  Show,
  SimpleList,
  SimpleShowLayout,
  TextField,
} from 'react-admin';

export const MessageDeleteQuery = gql`
  mutation DeleteMessages($ids: [ID!]!) {
    deleteMessages(input: {messageIds: $ids}) {
      messages {
        id
      }
    }
  }
`;

export const MessageListQuery = gql`
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
`;

export const MessageList = props => (
  <List sort={{ field: 'createdAt', order: 'DESC' }} {...props}>
    <Responsive
      small={(
        <SimpleList
          primaryText={record => record.name}
          secondaryText={record => record.email}
          tertiaryText={record => new Date(record.createdAt).toLocaleDateString()}
          linkType="show"
        />
      )}
      medium={(
        <Datagrid rowClick="show">
          <TextField source="name" />
          <TextField source="email" />
          <TextField source="phone" />
          <DateField source="createdAt" showTime />
        </Datagrid>
      )}
    />
  </List>
);

export const MessageShowQuery = gql`
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
`;

const MessageTitle = ({ record }) => (
  <span>{ `Message from ${record.name}` }</span>
);

const MessageShowActions = ({ basePath, data, resource }) => (
  <CardActions>
    <ListButton basePath={basePath} />
    <DeleteButton basePath={basePath} record={data} resource={resource} />
  </CardActions>
);

export const MessageShow = props => (
  <Show title={<MessageTitle />} actions={<MessageShowActions />} {...props}>
    <SimpleShowLayout>
      <TextField source="name" />
      <TextField source="email" />
      <TextField source="phone" />
      <DateField source="createdAt" showTime />
      <RichTextField source="message" />
    </SimpleShowLayout>
  </Show>
);
