import _ from "lodash";

import {
  MessageDeleteQuery,
  MessageListQuery,
  MessageShowQuery
} from "./components/messages";

export const query = introspectionResults => (fetchType, resource, params) => {
  switch (fetchType) {
  case "DELETE":
    return {
      query: MessageDeleteQuery,
      variables: {
        ids: [params.id]
      },
      parseResponse: response => ({
        data: response.data.deleteMessages.messages[0]
      })
    };
  case "DELETE_MANY":
    return {
      query: MessageDeleteQuery,
      variables: {
        ids: params.ids
      },
      parseResponse: response => ({
        data: response.data.deleteMessages.messages
      })
    };
  case "GET_LIST":
    return {
      query: MessageListQuery,
      variables: {
        first: params.pagination.perPage,
        after: btoa((params.pagination.page - 1) * params.pagination.perPage),
        orderBy: {
          field: _.toUpper(_.snakeCase(params.sort.field)),
          direction: params.sort.order
        }
      },
      parseResponse: response => ({
        data: response.data.messages.nodes,
        total: response.data.messages.totalCount
      })
    };
  case "GET_ONE":
    return {
      query: MessageShowQuery,
      variables: {
        id: params.id
      },
      parseResponse: response => ({
        data: response.data.node
      })
    };
  }
};
