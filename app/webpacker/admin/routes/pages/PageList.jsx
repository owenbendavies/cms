import React from 'react';
import {
  BooleanField,
  BulkDeleteButton,
  Datagrid,
  List,
  Responsive,
  SimpleList,
  TextField,
} from 'react-admin';

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
