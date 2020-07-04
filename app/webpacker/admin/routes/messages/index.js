import MessageIcon from '@material-ui/icons/Email';
import { MessageList } from './MessageList';
import { MessageShow } from './MessageShow';

export const messageOptions = {
  icon: MessageIcon,
  list: MessageList,
  name: 'messages',
  show: MessageShow,
};
