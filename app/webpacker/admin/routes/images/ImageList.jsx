import GridList from '@material-ui/core/GridList';
import GridListTile from '@material-ui/core/GridListTile';
import React from 'react';
import { List, Pagination } from 'react-admin';

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

export const ImageList = (props) => (
  <List pagination={<ImagePagination />} perPage={12} {...props}>
    <ImageGrid />
  </List>
);
