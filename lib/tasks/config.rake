namespace :config do
  desc "Configure Nginx"
  task nginx: :environment do
    site_hosts = Site.all.map(&:host).sort

    File.open('/etc/nginx/sites-available/cms', 'w') do |file|
      file.puts <<EOF
upstream cms_server {
  server unix:/var/www/cms/shared/tmp/sockets/unicorn.sock fail_timeout=0;
}

server {
EOF

      site_hosts.each do |host|
        if host.match /^www/
          bare_host = host.gsub(/^www\./, '')

          file.puts <<EOF
  server_name #{bare_host} #{host};

  if ($host = #{bare_host}) {
    rewrite ^(.*)$ http://www.$host$1 permanent;
  }

EOF

        else
          file.puts <<EOF
  server_name #{host};

EOF
        end
      end

      file.puts <<EOF
  root /var/www/cms/current/public;

  try_files \$uri @app;

  location @app {
    include /etc/nginx/proxy_params;
    proxy_redirect off;
    proxy_pass http://cms_server;
  }

  location ~ ^/assets/ {
    gzip_static on;
    expires 1y;
    add_header Cache-Control public;
  }

  error_page 500 /500.html;
  error_page 502 /502.html;

  access_log /var/log/nginx/cms-access.log;
  error_log /var/log/nginx/cms-error.log;
}
EOF
    end
  end
end
