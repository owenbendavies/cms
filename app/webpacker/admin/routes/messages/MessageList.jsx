import React from 'react';
import {
  BulkDeleteButton,
  Datagrid,
  DateField,
  EmailField,
  List,
  Responsive,
  SimpleList,
  TextField,
} from 'react-admin';

const MessageBulkActions = (props) => (
  <BulkDeleteButton undoable={false} {...props} />
);

export const MessageList = (props) => (
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
