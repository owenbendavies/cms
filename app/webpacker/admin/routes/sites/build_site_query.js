import gql from 'graphql-tag';

export const sitesQueries = {
  GET_LIST: gql`
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
  `,
  GET_ONE: gql`
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
  `,
};
