import React from "react";
import ReactTable from "react-table";
import Swagger from "swagger-client";

export default class Messages extends React.Component {
  constructor() {
    super();

    this.state = {
      data: [],
      pages: null,
      loading: true
    };

    this.fetchData = this.fetchData.bind(this);
  }

  fetchData(state) {
    this.setState({ loading: true });

    Swagger("/api/swagger").then(client => {
      return client.apis.messages.getMessages({
        page: state.page + 1,
        per_page: state.pageSize
      });
    }).then(response => {
      const total = response.headers["x-total"];
      const perPage = response.headers["x-per-page"];
      const pages = Math.ceil(total / perPage);

      this.setState({
        data: response.body,
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
            accessor: "created_at"
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
