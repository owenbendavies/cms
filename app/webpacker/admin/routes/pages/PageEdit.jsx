import React from 'react';
import { Edit } from 'react-admin';
import { PageForm } from './PageForm';

const PageTitle = ({ record }) => <span>{`Page ${record.name}`}</span>;

export const PageEdit = (props) => (
  <Edit title={<PageTitle />} mutationMode="pessimistic" {...props}>
    <PageForm />
  </Edit>
);
