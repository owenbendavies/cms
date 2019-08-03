import React from 'react';

import GridList from '@material-ui/core/GridList';
import GridListTile from '@material-ui/core/GridListTile';

import { List } from 'react-admin';

const ImageGrid = ({ ids, data }) => (
  <GridList cellHeight="auto" cols={4}>
    {ids.map(id => (
      <GridListTile key={id}>
        <img src={data[id].urlSpan3} alt={data[id].name} />
      </GridListTile>
    ))}
  </GridList>
);

export const ImageList = props => (
  <List {...props}>
    <ImageGrid />
  </List>
);
