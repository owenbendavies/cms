import gql from "graphql-tag";
import React from "react";

import {
  Datagrid,
  DateField,
  List,
  RichTextField,
  Show,
  SimpleShowLayout,
  TextField
} from "react-admin";

export const MessageListQuery = gql`
  query Messages($first: Int, $after: String) {
    messages(first: $first, after: $after) {
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

export const MessageList = (props) => (
  <List bulkActions={false} {...props}>
    <Datagrid rowClick="show">
      <TextField source="name" sortable={false} />
      <TextField source="email" sortable={false} />
      <TextField source="phone" sortable={false} />
      <DateField source="createdAt" showTime sortable={false} />
    </Datagrid>
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

export const MessageShow = (props) => (
  <Show title={<MessageTitle />} {...props}>
    <SimpleShowLayout>
      <TextField source="name" />
      <TextField source="email" />
      <TextField source="phone" />
      <DateField source="createdAt" showTime />
      <RichTextField source="message" />
    </SimpleShowLayout>
  </Show>
);
