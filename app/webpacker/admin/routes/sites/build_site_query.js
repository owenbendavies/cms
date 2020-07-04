import gql from 'graphql-tag';
import _ from 'lodash';

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

const buildGetListQuery = (params) => ({
  query: ListQuery,
  variables: {
    first: params.pagination.perPage,
    after: btoa((params.pagination.page - 1) * params.pagination.perPage),
  },
  parseResponse: (response) => ({
    data: response.data.sites.nodes,
    total: response.data.sites.totalCount,
  }),
});

const ShowQuery = gql`
  query Node($id: ID!) {
    node(id: $id) {
      id
      ... on Site {
        address
        email
        name
        googleAnalytics
        charityNumber
        mainMenuInFooter
        separateHeader
        css
      }
    }
  }
`;

const buildGetOneQuery = (params) => ({
  query: ShowQuery,
  variables: {
    id: params.id,
  },
  parseResponse: (response) => ({
    data: response.data.node,
  }),
});

const UpdateQuery = gql`
  mutation UpdateSite($input: UpdateSiteInput!) {
    updateSite(input: $input) {
      site {
        id
      }
    }
  }
`;

const updateVariables = (params) => {
  const changedData = _.omitBy(
    params.data,
    (value, key) => params.previousData[key] === value
  );

  return { siteId: params.data.id, ...changedData };
};

const buildUpdateQuery = (params) => ({
  query: UpdateQuery,
  variables: {
    input: updateVariables(params),
  },
  parseResponse: (response) => ({
    data: response.data.updateSite.site,
  }),
});

export const buildSiteQuery = (fetchType, params) => {
  switch (fetchType) {
    case 'GET_LIST':
      return buildGetListQuery(params);
    case 'GET_ONE':
      return buildGetOneQuery(params);
    case 'UPDATE':
      return buildUpdateQuery(params);
    default:
      throw new Error(`Unkown fetchType ${fetchType}`);
  }
};
