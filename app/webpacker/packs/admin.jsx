import React from 'react';
import ReactDom from 'react-dom';
import { App } from '../admin/App';

document.addEventListener('DOMContentLoaded', () => {
  ReactDom.render(<App />, document.getElementById('js-react-admin'));
});
