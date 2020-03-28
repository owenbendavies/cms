import React from 'react';

import {
  CardActions,
  DateField,
  DeleteButton,
  EmailField,
  RichTextField,
  Show,
  SimpleShowLayout,
  TextField,
} from 'react-admin';

const MessageTitle = ({ record }) => (
  <span>{`Message from ${record.name}`}</span>
);

const MessageShowActions = ({ basePath, data, resource }) => (
  <CardActions>
    <DeleteButton basePath={basePath} record={data} resource={resource} />
  </CardActions>
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
