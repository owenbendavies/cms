import PageIcon from '@material-ui/icons/Subject';
import { PageCreate } from './PageCreate';
import { PageEdit } from './PageEdit';
import { PageList } from './PageList';

export const pageOptions = {
  create: PageCreate,
  edit: PageEdit,
  icon: PageIcon,
  list: PageList,
  name: 'pages',
};
