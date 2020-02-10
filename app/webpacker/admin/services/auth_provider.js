import { Auth } from 'aws-amplify';

export const authProvider = {
  login: () => Promise.resolve(),
  logout: () => Auth.signOut(),
  checkAuth: () => Promise.resolve(),
  getPermissions: () => Promise.resolve(),
};
