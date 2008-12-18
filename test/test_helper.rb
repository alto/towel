ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'mocha'

class Test::Unit::TestCase

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  def assert_not_routing(path)
    assert_raise ActionController::MethodNotAllowed do
      assert_routing(path, {})
    end
  end
  
end

def valid_user_options(options={})
  login = options[:login] || 'dude'
  { :login                  => login,
    :email                  => "#{login}@test.com",
    :password               => 'password',
    :password_confirmation  => 'password' }.merge(options)
end
def build_user(options={}); User.new(valid_user_options(options)); end
def create_user(options={}); (o = build_user(options)).save!; o.activate; o; end

def valid_project_options(options={})
  { :name => 'project',
    :user => options[:user] || create_user }.merge(options)
end
def build_project(options={}); Project.new(valid_project_options(options)); end
def create_project(options={}); (o = build_project(options)).save!; o; end

