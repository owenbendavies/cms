import React from 'react';
import {
  Datagrid,
  DateField,
  EmailField,
  List,
  Responsive,
  SimpleList,
  TextField,
} from 'react-admin';

export const MessageList = (props) => (
  <List sort={{ field: 'createdAt', order: 'DESC' }} {...props}>
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
