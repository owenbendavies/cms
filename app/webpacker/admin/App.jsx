import ApolloClient from 'apollo-boost';
import buildGraphQLProvider from 'ra-data-graphql';
import React from 'react';
import { Admin, Resource } from 'react-admin';
import { imageOptions } from './routes/images';
import { messageOptions } from './routes/messages';
import { pageOptions } from './routes/pages';
import { siteOptions } from './routes/sites';
import { buildQuery } from './services/build_query';

export class App extends React.Component {
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
      <Admin dataProvider={dataProvider}>
        <Resource {...imageOptions} />
        <Resource {...messageOptions} />
        <Resource {...pageOptions} />
        <Resource {...siteOptions} />
      </Admin>
    );
  }
}
