import {
  MessageListQuery,
  MessageShowQuery
} from "./components/messages";

export const query = introspectionResults => (fetchType, resource, params) => {
  switch (fetchType) {
  case "GET_LIST":
    return {
      query: MessageListQuery,
      variables: {
        "first": params.pagination.perPage,
        "after": btoa((params.pagination.page - 1) * params.pagination.perPage)
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
        "id": params.id
      },
      parseResponse: response => ({
        data: response.data.node
      })
    };
  }
};
