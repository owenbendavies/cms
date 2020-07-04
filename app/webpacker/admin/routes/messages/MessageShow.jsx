import React from 'react';
import {
  DateField,
  DeleteButton,
  EmailField,
  RichTextField,
  Show,
  SimpleShowLayout,
  TextField,
  TopToolbar,
} from 'react-admin';

const MessageTitle = ({ record }) => (
  <span>{`Message from ${record.name}`}</span>
);

const MessageShowActions = ({ basePath, data, resource }) => (
  <TopToolbar>
    <DeleteButton
      undoable={false}
      basePath={basePath}
      record={data}
      resource={resource}
    />
  </TopToolbar>
);

export const MessageShow = (props) => (
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
