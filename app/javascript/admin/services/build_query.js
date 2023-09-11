import gql from 'graphql-tag';
import _ from 'lodash';

import { imagesQueries } from '../routes/images';
import { messagesQueries } from '../routes/messages';
import { pagesQueries } from '../routes/pages';
import { sitesQueries } from '../routes/sites';

const queries = {
  images: imagesQueries,
  messages: messagesQueries,
  pages: pagesQueries,
  sites: sitesQueries,
};

const capitalize = (string) => string.charAt(0).toUpperCase() + string.slice(1);

const singularize = (string) => string.slice(0, -1);

const capitalSingularize = (string) => singularize(capitalize(string));

const buildCreateQuery = (resource, params) => ({
  parseResponse: (response) => ({
    data: response.data[`create${capitalSingularize(resource)}`][
      singularize(resource)
    ],
  }),
  query: gql`
    mutation Create${capitalSingularize(
      resource
    )}($input: Create${capitalSingularize(resource)}Input!) {
      create${capitalSingularize(resource)}(input: $input) {
        ${singularize(resource)} {
          id
        }
      }
    }
  `,
  variables: {
    input: params.data,
  },
});

const deleteQuery = (resource) => gql`
  mutation Delete${capitalize(resource)}($ids: [ID!]!) {
    delete${capitalize(resource)}(input: { ${singularize(
  resource
)}Ids: $ids }) {
      ${resource} {
        id
      }
    }
  }
`;

const buildDeleteQuery = (resource, params) => ({
  parseResponse: (response) => ({
    data: response.data[`delete${capitalize(resource)}`][resource][0],
  }),
  query: deleteQuery(resource),
  variables: {
    ids: [params.id],
  },
});

const buildDeleteManyQuery = (resource, params) => ({
  parseResponse: (response) => ({
    data: response.data[`delete${capitalize(resource)}`][resource],
  }),
  query: deleteQuery(resource),
  variables: {
    ids: params.ids,
  },
});

const buildGetListQuery = (fetchType, resource, params) => ({
  parseResponse: (response) => ({
    data: response.data[resource].nodes,
    total: response.data[resource].totalCount,
  }),
  query: queries[resource][fetchType],
  variables: {
    after: btoa((params.pagination.page - 1) * params.pagination.perPage),
    first: params.pagination.perPage,
    orderBy: {
      direction: params.sort.order,
      field: _.toUpper(_.snakeCase(params.sort.field)),
    },
  },
});

const buildGetOneQuery = (fetchType, resource, params) => ({
  parseResponse: (response) => ({
    data: response.data.node,
  }),
  query: queries[resource][fetchType],
  variables: {
    id: params.id,
  },
});

const updateVariables = (resource, params) => {
  const changedData = _.omitBy(
    params.data,
    (value, key) => params.previousData[key] === value
  );

  return {
    [`${singularize(resource)}Id`]: params.data.id,
    ...changedData,
  };
};

const buildUpdateQuery = (resource, params) => ({
  parseResponse: (response) => ({
    data: response.data[`update${capitalSingularize(resource)}`][
      singularize(resource)
    ],
  }),
  query: gql`
    mutation Update${capitalSingularize(
      resource
    )}($input: Update${capitalSingularize(resource)}Input!) {
      update${capitalSingularize(resource)}(input: $input) {
        ${singularize(resource)} {
          id
        }
      }
    }
  `,
  variables: {
    input: updateVariables(resource, params),
  },
});

export const buildQuery = () => (fetchType, resource, params) => {
  switch (fetchType) {
    case 'CREATE':
      return buildCreateQuery(resource, params);
    case 'DELETE_MANY':
      return buildDeleteManyQuery(resource, params);
    case 'DELETE':
      return buildDeleteQuery(resource, params);
    case 'GET_LIST':
      return buildGetListQuery(fetchType, resource, params);
    case 'GET_ONE':
      return buildGetOneQuery(fetchType, resource, params);
    case 'UPDATE':
      return buildUpdateQuery(resource, params);
    default:
      throw new Error(`Unknown fetchType ${fetchType}`);
  }
};
