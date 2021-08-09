import gql from 'graphql-tag';

export const pagesQueries = {
  GET_LIST: gql`
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
  `,
  GET_ONE: gql`
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
  `,
};
