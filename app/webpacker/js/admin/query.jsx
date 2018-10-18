import gql from "graphql-tag";

export const query = introspectionResults => (fetchType, resource, params) => {
  switch (fetchType) {
  case "GET_ONE":
    return {
      query: gql`
        query Node($id: ID!) {
          node(id: $id) {
            id
            ... on Message {
              name
              email
              phone
              message
              createdAt
            }
          }
        }
      `,
      variables: {
        "id": params.id
      },
      parseResponse: response => ({ data: response.data.node })
    };
  case "GET_LIST":
    return {
      query: gql`
        query Messages($first: Int, $after: String) {
          messages(first: $first, after: $after) {
            nodes {
              id
              name
              email
              phone
              createdAt
            }
            totalCount
          }
        }
      `,
      variables: {
        "first": params.pagination.perPage,
        "after": btoa((params.pagination.page - 1) * params.pagination.perPage)
      },
      parseResponse: response => ({
        data: response.data.messages.nodes,
        total: response.data.messages.totalCount
      })
    };
  }
};
