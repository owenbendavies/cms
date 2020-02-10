import Amplify from 'aws-amplify';
import React from 'react';
import ReactDom from 'react-dom';

import { App } from '../admin/App';

document.addEventListener('DOMContentLoaded', () => {
  const adminData = JSON.parse(
    document.getElementById('js-admin-data').getAttribute('data')
  );

  Amplify.configure({
    Auth: {
      mandatorySignIn: true,
      userPoolId: adminData.awsCognitoUserPoolId,
      userPoolWebClientId: adminData.awsCognitoClientId,
    },
  });

  ReactDom.render(<App />, document.getElementById('js-react-admin'));
});
