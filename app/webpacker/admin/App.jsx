import { Admin, Resource } from 'react-admin';
import ApolloClient from 'apollo-boost';
import buildGraphQLProvider from 'ra-data-graphql';
import ImageIcon from '@material-ui/icons/Image';
import MessageIcon from '@material-ui/icons/Email';
import PageIcon from '@material-ui/icons/Subject';
import SiteIcon from '@material-ui/icons/Language';
import React from 'react';

import { buildQuery } from './services/build_query';

import { ImageList } from './routes/images/ImageList';
import { MessageList } from './routes/messages/MessageList';
import { MessageShow } from './routes/messages/MessageShow';
import { PageList } from './routes/pages/PageList';
import { SiteEdit } from './routes/sites/SiteEdit';
import { SiteList } from './routes/sites/SiteList';

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
    }).then(dataProvider => this.setState({ dataProvider }));
  }

  render() {
    const { dataProvider } = this.state;

    if (!dataProvider) {
      return <div>Loading</div>;
    }

    return (
      <Admin dataProvider={dataProvider}>
        <Resource icon={ImageIcon} list={ImageList} name="images" />
        <Resource
          icon={MessageIcon}
          list={MessageList}
          name="messages"
          show={MessageShow}
        />
        <Resource icon={PageIcon} list={PageList} name="pages" />
        <Resource
          edit={SiteEdit}
          icon={SiteIcon}
          list={SiteList}
          name="sites"
        />
      </Admin>
    );
  }
}
