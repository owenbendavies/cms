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

export const MessageList = (props) => (
  <List bulkActions={false} sort={{ field: "createdAt", order: "DESC" }} {...props}>
    <Datagrid rowClick="show">
      <TextField source="name" />
      <TextField source="email" />
      <TextField source="phone" />
      <DateField source="createdAt" showTime />
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
