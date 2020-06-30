import _ from 'lodash';
import gql from 'graphql-tag';

const CreateQuery = gql`
  mutation CreatePage($input: CreatePageInput!) {
    createPage(input: $input) {
      page {
        id
      }
    }
  }
`;

const buildCreateQuery = (params) => ({
  query: CreateQuery,
  variables: {
    input: params.data,
  },
  parseResponse: (response) => ({
    data: response.data.createPage.page,
  }),
});

const DeleteQuery = gql`
  mutation DeletePages($ids: [ID!]!) {
    deletePages(input: { pageIds: $ids }) {
      pages {
        id
      }
    }
  }
`;

const buildDeleteQuery = (params) => ({
  query: DeleteQuery,
  variables: {
    ids: [params.id],
  },
  parseResponse: (response) => ({
    data: response.data.deletePages.pages[0],
  }),
});

const buildDeleteManyQuery = (params) => ({
  query: DeleteQuery,
  variables: {
    ids: params.ids,
  },
  parseResponse: (response) => ({
    data: response.data.deletePages.pages,
  }),
});

const ListQuery = gql`
  query Pages($first: Int, $after: String) {
    pages(first: $first, after: $after) {
      nodes {
        id
        name
        private
        contactForm
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
    data: response.data.pages.nodes,
    total: response.data.pages.totalCount,
  }),
});

const ShowQuery = gql`
  query Node($id: ID!) {
    node(id: $id) {
      id
      ... on Page {
        contactForm
        htmlContent
        name
        private
        url
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
  mutation UpdatePage($input: UpdatePageInput!) {
    updatePage(input: $input) {
      page {
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

  return { pageId: params.data.id, ...changedData };
};

const buildUpdateQuery = (params) => ({
  query: UpdateQuery,
  variables: {
    input: updateVariables(params),
  },
  parseResponse: (response) => ({
    data: response.data.updatePage.page,
  }),
});

export const buildPageQuery = (fetchType, params) => {
  switch (fetchType) {
    case 'CREATE':
      return buildCreateQuery(params);
    case 'DELETE':
      return buildDeleteQuery(params);
    case 'DELETE_MANY':
      return buildDeleteManyQuery(params);
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
