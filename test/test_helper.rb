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

def login_me(user) # refactor to login(user)
  @controller.stubs(:logged_in?).returns(true)
  @controller.stubs(:current_user).returns(user)
  @request.session[:user] = user
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

def valid_card_options(options={})
  { :title    => 'card_title',
    :project  => options.keys.include?(:project) ? options[:project] : create_project,
  }.merge(options)
end
def build_card(options={}); Card.new(valid_card_options(options)); end
def create_card(options={}); (o = build_card(options)).save!; o; end

require 'time'
if !Time.respond_to?('now_old')
  Time.class_eval {
    @@advance_by_days = 0
    @@advance_by_minutes = 0
    cattr_accessor :advance_by_days, :advance_by_minutes

    class << Time
      alias now_old now
      def now
        if Time.advance_by_days != 0
          return Time.at(now_old.to_i + Time.advance_by_days * 60 * 60 * 24 + 1)
        elsif Time.advance_by_minutes != 0
          return Time.at(now_old.to_i + Time.advance_by_minutes * 60)
        else
          now_old
        end
      end
    end
  }
end
