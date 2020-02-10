import { Admin, Resource } from 'react-admin';

import {
  AmplifyTheme,
  ConfirmSignIn,
  ForgotPassword,
  RequireNewPassword,
  SignIn,
  VerifyContact,
  withAuthenticator,
} from 'aws-amplify-react';

import ApolloClient from 'apollo-boost';
import buildGraphQLProvider from 'ra-data-graphql';
import React from 'react';

import { authProvider } from './services/auth_provider';
import { buildQuery } from './services/build_query';

import { imageOptions } from './routes/images';
import { messageOptions } from './routes/messages';
import { pageOptions } from './routes/pages';
import { siteOptions } from './routes/sites';

class SignedInApp extends React.Component {
  constructor() {
    super();

    this.state = {
      dataProvider: null,
    };
  }

  componentDidMount() {
    const csrfToken = document
      .querySelector('meta[name=csrf-token]')
      .getAttribute('content');

    const client = new ApolloClient({
      headers: {
        'X-CSRF-Token': csrfToken,
      },
    });

    buildGraphQLProvider({
      buildQuery,
      client,
    }).then((dataProvider) => this.setState({ dataProvider }));
  }

  render() {
    const { dataProvider } = this.state;

    if (!dataProvider) {
      return <div>Loading</div>;
    }

    return (
      <Admin authProvider={authProvider} dataProvider={dataProvider}>
        <Resource {...imageOptions} />
        <Resource {...messageOptions} />
        <Resource {...pageOptions} />
        <Resource {...siteOptions} />
      </Admin>
    );
  }
}

export const App = withAuthenticator(SignedInApp, {
  theme: AmplifyTheme,
  authenticatorComponents: [
    <SignIn />,
    <ConfirmSignIn />,
    <VerifyContact />,
    <ForgotPassword />,
    <RequireNewPassword />,
  ],
});
