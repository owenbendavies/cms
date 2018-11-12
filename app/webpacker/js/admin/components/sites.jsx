import gql from 'graphql-tag';
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

const ListQuery = gql`
  query Sites($first: Int, $after: String) {
    sites(first: $first, after: $after) {
      nodes {
        id
        address
        name
        email
        googleAnalytics
        charityNumber
      }
      totalCount
    }
  }
`;

const buildGetListQuery = params => ({
  query: ListQuery,
  variables: {
    first: params.pagination.perPage,
    after: btoa((params.pagination.page - 1) * params.pagination.perPage),
  },
  parseResponse: response => ({
    data: response.data.sites.nodes,
    total: response.data.sites.totalCount,
  }),
});

export const SiteList = props => (
  <List bulkActions={false} {...props}>
    <Responsive
      small={(
        <SimpleList
          primaryText={record => record.name}
          secondaryText={record => record.address}
        />
      )}
      medium={(
        <Datagrid>
          <TextField source="name" sortable={false} />
          <UrlField source="address" sortable={false} />
          <EmailField source="email" sortable={false} />
          <TextField source="googleAnalytics" sortable={false} />
          <TextField source="charityNumber" sortable={false} />
        </Datagrid>
      )}
    />
  </List>
);

export const buildSiteQuery = (fetchType, params) => {
  switch (fetchType) {
    case 'GET_LIST': return buildGetListQuery(params);
    default: throw new Error(`Unkown fetchType ${fetchType}`);
  }
};
