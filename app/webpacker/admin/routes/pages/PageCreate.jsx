import React from 'react';
import { Create } from 'react-admin';
import { PageForm } from './PageForm';

export const PageCreate = (props) => (
  <Create {...props}>
    <PageForm />
  </Create>
);
