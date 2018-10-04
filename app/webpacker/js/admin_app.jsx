import { Admin, Resource } from "react-admin";
import ApolloClient from "apollo-boost";
import buildGraphQLProvider from "ra-data-graphql";
import EmailIcon from "@material-ui/icons/Email";
import React from "react";

import { query } from "./admin/query";
import { MessageList, MessageShow } from "./admin/components/messages";

export class AdminApp extends React.Component {
  constructor() {
    super();

    this.state = {
      dataProvider: null
    };
  }

  componentDidMount() {
    const csrfToken = document.querySelector("meta[name=csrf-token]").getAttribute("content");

    const client = new ApolloClient({
      headers: {
        "X-CSRF-Token": csrfToken
      }
    });

    buildGraphQLProvider({
      buildQuery: query,
      client: client
    }).then(dataProvider => this.setState({ dataProvider }));
  }

  render() {
    if (!this.state.dataProvider) {
      return <div>Loading</div>;
    }

    return (
      <Admin dataProvider={this.state.dataProvider}>
        <Resource
          icon={EmailIcon}
          list={MessageList}
          name="messages"
          show={MessageShow}
        />
      </Admin>
    );
  }
}
