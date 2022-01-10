import GridList from '@material-ui/core/GridList';
import GridListTile from '@material-ui/core/GridListTile';
import ImageIcon from '@material-ui/icons/Image';
import gql from 'graphql-tag';
import React from 'react';
import { List, Pagination } from 'react-admin';

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

const ImageGrid = ({ ids, data }) => (
  <GridList cols={4}>
    {ids.map((id) => (
      <GridListTile key={id}>
        <img src={data[id].urlThumbnail} alt={data[id].name} />
      </GridListTile>
    ))}
  </GridList>
);

const ImagePagination = (props) => (
  <Pagination rowsPerPageOptions={[12, 24, 36, 48]} {...props} />
);

const ImageList = (props) => (
  <List pagination={<ImagePagination />} perPage={12} {...props}>
    <ImageGrid />
  </List>
);

export const imageOptions = {
  icon: ImageIcon,
  list: ImageList,
  name: 'images',
};
