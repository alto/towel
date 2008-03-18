module MailerSpecHelper

  FIXTURES_PATH = File.dirname(__FILE__) + '/fixtures' unless defined?(FIXTURES_PATH)
  CHARSET = 'utf-8' unless defined?(CHARSET)
  
private

    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/mailers/#{action}")
    end

end
