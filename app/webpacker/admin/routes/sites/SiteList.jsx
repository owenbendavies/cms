import React from 'react';

import {
  Datagrid,
  EmailField,
  List,
  Responsive,
  SimpleList,
  TextField,
  UrlField,
} from 'react-admin';

export const SiteList = props => (
  <List bulkActionButtons={false} {...props}>
    <Responsive
      small={
        <SimpleList
          primaryText={record => record.name}
          secondaryText={record => record.address}
          linkType="edit"
        />
      }
      medium={
        <Datagrid rowClick="edit">
          <TextField source="name" sortable={false} />
          <UrlField source="address" sortable={false} />
          <EmailField source="email" sortable={false} />
          <TextField source="googleAnalytics" sortable={false} />
          <TextField source="charityNumber" sortable={false} />
        </Datagrid>
      }
    />
  </List>
);
