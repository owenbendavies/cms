import BootstrapTable from 'react-bootstrap-table-next'
import PropTypes from "prop-types"
import React from "react"
import ReactDOM from "react-dom"
import Swagger from "swagger-client"

document.addEventListener("turbolinks:load", () => {
  Swagger('/api/swagger')
    .then( client => {
      return client.apis.messages.getMessages();
    })
    .then( response => {
      const messages = response.body

      const columns = [{
        dataField: 'name',
        text: 'Name'
      }, {
        dataField: 'email',
        text: 'Email'
      }, {
        dataField: 'created_at',
        text: 'Created At'
      }];

      ReactDOM.render(
        <BootstrapTable classes="messages" keyField='created_at' data={messages} columns={columns} />,
        document.getElementById("js-react-admin")
      );
    });
});
