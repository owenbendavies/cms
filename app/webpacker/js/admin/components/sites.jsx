import gql from 'graphql-tag';
import React from 'react';

import {
  Datagrid,
  List,
  Responsive,
  SimpleList,
  TextField,
} from 'react-admin';

const ListQuery = gql`
  query Sites($first: Int, $after: String) {
    sites(first: $first, after: $after) {
      nodes {
        id
        address
        name
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

const SiteLink = (props) => {
  const { record } = props;

  return (
    <a href={record.address}>
      <TextField source="address" {...props} />
    </a>
  );
};

export const SiteList = props => (
  <List bulkActions={false} {...props}>
    <Responsive
      small={(
        <SimpleList
          primaryText={record => record.name}
          secondaryText={record => record.address}
          linkType="show"
        />
      )}
      medium={(
        <Datagrid>
          <TextField source="name" sortable={false} />
          <SiteLink />
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
