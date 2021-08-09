import gql from 'graphql-tag';

export const imagesQueries = {
  GET_LIST: gql`
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
  `,
};
