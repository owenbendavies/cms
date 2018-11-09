import gql from 'graphql-tag';
import React from 'react';

import {
  BooleanField,
  Datagrid,
  List,
  Responsive,
  SimpleList,
  TextField,
} from 'react-admin';

const ListQuery = gql`
  query Pages($first: Int, $after: String) {
    pages(first: $first, after: $after) {
      nodes {
        id
        name
        private
        hidden
        contactForm
      }
      totalCount
    }
  }
`;

const DeleteQuery = gql`
  mutation DeletePages($ids: [ID!]!) {
    deletePages(input: {pageIds: $ids}) {
      pages {
        id
      }
    }
  }
`;

const buildDeleteManyQuery = params => ({
  query: DeleteQuery,
  variables: {
    ids: params.ids,
  },
  parseResponse: response => ({
    data: response.data.deletePages.pages,
  }),
});

const buildGetListQuery = params => ({
  query: ListQuery,
  variables: {
    first: params.pagination.perPage,
    after: btoa((params.pagination.page - 1) * params.pagination.perPage),
  },
  parseResponse: response => ({
    data: response.data.pages.nodes,
    total: response.data.pages.totalCount,
  }),
});

export const PageList = props => (
  <List {...props}>
    <Responsive
      small={(
        <SimpleList
          primaryText={record => record.name}
        />
      )}
      medium={(
        <Datagrid>
          <TextField source="name" sortable={false} />
          <BooleanField source="private" sortable={false} />
          <BooleanField source="hidden" sortable={false} />
          <BooleanField source="contactForm" sortable={false} />
        </Datagrid>
      )}
    />
  </List>
);

export const buildPageQuery = (fetchType, params) => {
  switch (fetchType) {
    case 'DELETE_MANY': return buildDeleteManyQuery(params);
    case 'GET_LIST': return buildGetListQuery(params);
    default: throw new Error(`Unkown fetchType ${fetchType}`);
  }
};
