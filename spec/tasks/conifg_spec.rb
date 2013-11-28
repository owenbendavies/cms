require 'spec_helper'
require 'rake'

describe 'config' do
  describe 'nginx' do
    def run_configure_nginx
      file_content = ""

      file = double

      allow(file).to receive(:puts) do |content|
        file_content << content
      end

      expect(File).to receive(:open).
        with('/etc/nginx/sites-available/cms', 'w').
        and_yield(file)

      rake = Rake::Application.new
      Rake.application = rake
      load Rails.root.join 'lib/tasks/config.rake'
      Rake::Task.define_task(:environment)
      rake['config:nginx'].invoke

      return file_content
    end

    it 'configures sites' do
      FactoryGirl.create(:site, host: 'example.com')
      FactoryGirl.create(:site, host: 'www.example.net')

      file_content = run_configure_nginx

      file_content.should include 'upstream cms_server'

      file_content.should include 'server_name example.com;'

      file_content.should include 'server_name example.net www.example.net;'
      file_content.should include 'if ($host = example.net)'

      file_content.should include 'root /var/www/cms/current/public;'
    end
  end
end
