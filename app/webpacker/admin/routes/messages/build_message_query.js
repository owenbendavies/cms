import gql from 'graphql-tag';

export const messagesQueries = {
  GET_LIST: gql`
    query Messages($first: Int, $after: String, $orderBy: MessageOrder!) {
      messages(first: $first, after: $after, orderBy: $orderBy) {
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
  GET_ONE: gql`
    query Node($id: ID!) {
      node(id: $id) {
        id
        ... on Message {
          name
          email
          phone
          createdAt
          message
        }
      }
    }
  `,
};
