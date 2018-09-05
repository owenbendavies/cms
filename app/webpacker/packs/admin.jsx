import React from "react";
import ReactDom from "react-dom";
import { BrowserRouter, Route } from "react-router-dom";

import Messages from "../js/admin/components/messages";

document.addEventListener("turbolinks:load", () => {
  ReactDom.render(
    <BrowserRouter basename="/admin">
      <div>
        <Route exact path="/messages" component={Messages}/>
      </div>
    </BrowserRouter>,
    document.getElementById("js-react-admin")
  );
});
