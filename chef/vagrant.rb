file '/etc/profile.d/vagrant.sh' do
  content <<EOF
if [ -n "$BASH_VERSION" ]
then
  cd /vagrant
fi
EOF
end

package 'htop'
package 'imagemagick'
package 'libqt5webkit5-dev'
package 'qt5-default'
package 'vim-nox'
package 'xvfb'

execute 'update-alternatives --set editor /usr/bin/vim.nox'
