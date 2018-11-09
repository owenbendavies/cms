import { Admin, Resource } from 'react-admin';
import ApolloClient from 'apollo-boost';
import buildGraphQLProvider from 'ra-data-graphql';
import MessageIcon from '@material-ui/icons/Email';
import PageIcon from '@material-ui/icons/Subject';
import SiteIcon from '@material-ui/icons/Language';
import React from 'react';

import buildQuery from './admin/build_query';
import { MessageList, MessageShow } from './admin/components/messages';
import { PageList } from './admin/components/pages';
import { SiteList } from './admin/components/sites';

export default class AdminApp extends React.Component {
  constructor() {
    super();

    this.state = {
      dataProvider: null,
    };
  }

  componentDidMount() {
    const csrfToken = document.querySelector('meta[name=csrf-token]').getAttribute('content');

    const client = new ApolloClient({
      headers: {
        'X-CSRF-Token': csrfToken,
      },
    });

    buildGraphQLProvider({
      buildQuery,
      client,
    }).then(dataProvider => this.setState({ dataProvider }));
  }

  render() {
    const { dataProvider } = this.state;

    if (!dataProvider) {
      return <div>Loading</div>;
    }

    return (
      <Admin dataProvider={dataProvider}>
        <Resource
          icon={MessageIcon}
          list={MessageList}
          name="messages"
          show={MessageShow}
        />
        <Resource
          icon={PageIcon}
          list={PageList}
          name="pages"
        />
        <Resource
          icon={SiteIcon}
          list={SiteList}
          name="sites"
        />
      </Admin>
    );
  }
}
