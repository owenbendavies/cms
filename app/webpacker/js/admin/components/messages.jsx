import _ from 'lodash';
import gql from 'graphql-tag';
import React from 'react';

import {
  CardActions,
  Datagrid,
  DateField,
  DeleteButton,
  List,
  ListButton,
  Responsive,
  RichTextField,
  Show,
  SimpleList,
  SimpleShowLayout,
  TextField,
} from 'react-admin';

const DeleteQuery = gql`
  mutation DeleteMessages($ids: [ID!]!) {
    deleteMessages(input: {messageIds: $ids}) {
      messages {
        id
      }
    }
  }
`;

const buildDeleteQuery = params => ({
  query: DeleteQuery,
  variables: {
    ids: [params.id],
  },
  parseResponse: response => ({
    data: response.data.deleteMessages.messages[0],
  }),
});

const buildDeleteManyQuery = params => ({
  query: DeleteQuery,
  variables: {
    ids: params.ids,
  },
  parseResponse: response => ({
    data: response.data.deleteMessages.messages,
  }),
});

const ListQuery = gql`
  query Messages($first: Int, $after: String, $orderBy: MessageOrder!) {
    messages(first: $first, after: $after, orderBy: $orderBy) {
      nodes {
        id
        name
        email
        phone
        createdAt
      }
      totalCount
    }
  }
`;

const buildGetListQuery = params => ({
  query: ListQuery,
  variables: {
    first: params.pagination.perPage,
    after: btoa((params.pagination.page - 1) * params.pagination.perPage),
    orderBy: {
      field: _.toUpper(_.snakeCase(params.sort.field)),
      direction: params.sort.order,
    },
  },
  parseResponse: response => ({
    data: response.data.messages.nodes,
    total: response.data.messages.totalCount,
  }),
});

export const MessageList = props => (
  <List sort={{ field: 'createdAt', order: 'DESC' }} {...props}>
    <Responsive
      small={(
        <SimpleList
          primaryText={record => record.name}
          secondaryText={record => record.email}
          tertiaryText={record => new Date(record.createdAt).toLocaleDateString()}
          linkType="show"
        />
      )}
      medium={(
        <Datagrid rowClick="show">
          <TextField source="name" />
          <TextField source="email" />
          <TextField source="phone" />
          <DateField source="createdAt" showTime />
        </Datagrid>
      )}
    />
  </List>
);

const ShowQuery = gql`
  query Node($id: ID!) {
    node(id: $id) {
      id
      ... on Message {
        name
        email
        phone
        createdAt
        message
      }
    }
  }
`;

const buildGetOneQuery = params => ({
  query: ShowQuery,
  variables: {
    id: params.id,
  },
  parseResponse: response => ({
    data: response.data.node,
  }),
});

const MessageTitle = ({ record }) => (
  <span>{ `Message from ${record.name}` }</span>
);

const MessageShowActions = ({ basePath, data, resource }) => (
  <CardActions>
    <ListButton basePath={basePath} />
    <DeleteButton basePath={basePath} record={data} resource={resource} />
  </CardActions>
);

export const MessageShow = props => (
  <Show title={<MessageTitle />} actions={<MessageShowActions />} {...props}>
    <SimpleShowLayout>
      <TextField source="name" />
      <TextField source="email" />
      <TextField source="phone" />
      <DateField source="createdAt" showTime />
      <RichTextField source="message" />
    </SimpleShowLayout>
  </Show>
);

export const buildMessageQuery = (fetchType, params) => {
  switch (fetchType) {
    case 'DELETE': return buildDeleteQuery(params);
    case 'DELETE_MANY': return buildDeleteManyQuery(params);
    case 'GET_LIST': return buildGetListQuery(params);
    case 'GET_ONE': return buildGetOneQuery(params);
    default: throw new Error(`Unkown fetchType ${fetchType}`);
  }
};
