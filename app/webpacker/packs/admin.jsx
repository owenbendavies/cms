import React from 'react';
import ReactDom from 'react-dom';

import AdminApp from '../js/admin_app';

document.addEventListener('DOMContentLoaded', () => {
  ReactDom.render(
    <AdminApp />,
    document.getElementById('js-react-admin'),
  );
});
