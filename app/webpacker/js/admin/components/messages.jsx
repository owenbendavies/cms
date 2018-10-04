import React from "react";

import {
  Datagrid,
  DateField,
  List,
  RichTextField,
  Show,
  ShowButton,
  SimpleShowLayout,
  TextField
} from "react-admin";

export const MessageList = (props) => (
  <List bulkActions={false} {...props}>
    <Datagrid>
      <TextField source="name" sortable={false} />
      <TextField source="email" sortable={false} />
      <TextField source="phone" sortable={false} />
      <DateField source="createdAt" showTime sortable={false} />
      <ShowButton />
    </Datagrid>
  </List>
);

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
