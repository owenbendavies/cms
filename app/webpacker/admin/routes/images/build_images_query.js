import gql from 'graphql-tag';

const ListQuery = gql`
  query Images($first: Int, $after: String) {
    images(first: $first, after: $after) {
      nodes {
        id
        name
        urlThumbnail
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
    data: response.data.images.nodes,
    total: response.data.images.totalCount,
  }),
});

export const buildImagesQuery = (fetchType, params) => {
  switch (fetchType) {
    case 'GET_LIST':
      return buildGetListQuery(params);
    default:
      throw new Error(`Unkown fetchType ${fetchType}`);
  }
};
