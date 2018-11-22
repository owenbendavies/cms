import gql from 'graphql-tag';

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

export const buildSiteQuery = (fetchType, params) => {
  switch (fetchType) {
    case 'GET_LIST': return buildGetListQuery(params);
    default: throw new Error(`Unkown fetchType ${fetchType}`);
  }
};
