import ApolloClient from "apollo-boost";
import React from "react";
import ReactTable from "react-table";
import gql from "graphql-tag";

export default class Messages extends React.Component {
  constructor() {
    super();

    this.state = {
      data: [],
      pages: null,
      loading: true
    };

    const csrfToken = document.querySelector("meta[name=csrf-token]").getAttribute("content");

    this.client = new ApolloClient({
      headers: {
        'X-CSRF-Token': csrfToken
      }
    });

    this.fetchData = this.fetchData.bind(this);
  }

  fetchData(state) {
    this.setState({ loading: true });

    this.client.query({
      query: gql`
        query Messages($first: Int, $after: String) {
          messages(first: $first, after: $after) {
            nodes {
              name
              email
              phone
              message
              createdAt
            }
            totalCount
          }
        }
      `,
      variables: {
        "first": state.pageSize,
        "after": btoa(state.page * state.pageSize)
      }
    }).then(result => {
      const total = result.data.messages.totalCount;
      const pages = Math.ceil(total / state.pageSize);

      this.setState({
        data: result.data.messages.nodes,
        pages: pages,
        loading: false
      });
    });
  }

  render() {
    return (
      <ReactTable
        columns={[
          {
            Header: "Name",
            accessor: "name"
          },
          {
            Header: "Email",
            accessor: "email"
          },
          {
            Header: "Phone",
            accessor: "phone"
          },
          {
            Header: "Created At",
            accessor: "createdAt"
          }
        ]}
        data={this.state.data}
        defaultPageSize={10}
        loading={this.state.loading}
        manual
        onFetchData={this.fetchData}
        pages={this.state.pages}
        sortable={false}
        SubComponent={row => {
          return (
            <p>{row.original.message}</p>
          )
        }}
      />
    );
  }
}
