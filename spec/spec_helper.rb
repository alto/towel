ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require File.dirname(__FILE__) + '/spec_models_helper'
require File.dirname(__FILE__) + '/spec_controllers_helper'
require File.dirname(__FILE__) + '/spec_views_helper'
require File.dirname(__FILE__) + '/spec_helpers_helper'
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures'
  
	config.include(ActiveRecordMatchers,  { :behaviour_type => :model      })
	config.include(SpecModelsHelper,      { :behaviour_type => :model  })
	config.include(SpecControllersHelper, { :behaviour_type => :controller  })
	config.include(SpecHelpersHelper,     { :behaviour_type => :helper })
	config.include(SpecViewsHelper,       { :behaviour_type => :view   })

	# raise errors in the specs
  class ActionController::Base; def rescue_action(e) raise; end; end
end

@@count = 0

def count 
  @@count += 1
end

def login_me(user) # refactor to login(user)
  controller.stub!(:logged_in?).and_return(true)
  controller.stub!(:current_user).and_return user
  @request.session[:user] = user
end

def valid_user_fields(login='dude')
  {
    :login                  => login,
    :url_slug               => login.to_url,
    :email                  => "#{login}@test.com",
    :password               => 'dudeishere',
    :password_confirmation  => 'dudeishere',
  }
end
def mock_user(options={})
  mock_fields = {
    :to_param             => options[:login] ? options[:login].to_url : 'dude',
    :url_slug             => options[:login] ? options[:login].to_url : 'dude',
    :display_name         => options[:login] || 'dude',
    :activation_code      => nil,
    :activated?           => true,
    :deleted?             => false,
    :admin?               => false,
    :description          => 'description',
    :role                 => nil,
    :role=                => true,
    :terms_of_service     => nil,
    :created_at           => Time.now,
    :delete!              => nil,
    :undelete!            => nil,
    :projects             => [],
  }
  mock_model(User, (options[:login].nil? ? valid_user_fields : valid_user_fields(options[:login])).merge(mock_fields).merge(options))
end
def mock_admin(options={})
  admin = mock_user(options)
  admin.stub!(:admin?).and_return(true)
  admin
end
def build_user(options={})
  u = User.new((options[:login].nil? ? valid_user_fields : valid_user_fields(options[:login])).merge(options))
  u.role = options[:role] if options[:role]
  u.created_at = options[:created_at] if options[:created_at]
  u.activated_at = Time.now
  u.activation_code = nil
  u
end
def create_user(options={})
  o = build_user(options)
  o.save!
  unless options.keys.include?(:activation_code)
    o.activation_code = nil
    o.activated_at = Time.now
    o.save!
  end
  o
end
def find_or_create_user(options={})
  User.find_by_login(options[:login] || 'dude') || create_user(options)
end
# def create_admin(options={})
#   admin = create_user(options.merge(:login => 'superman'))
#   admin.role = 'admin'
#   admin.save!
#   admin
# end

def valid_project_fields(options={})
  {
    :name => 'project_name',
    :user => find_or_create_user,
  }.merge(options)
end
def mock_project(options={})
  mock_fields = {
    :to_param   => options[:name] ? options[:name].to_url : 'project_name',
    :url_slug   => options[:name] ? options[:name].to_url : 'project_name',
    :cards      => [],
    :name       => 'project name',
    :created_at => Time.now,
  }
  mock_model(Project, mock_fields)
end
def build_project(options={}); Project.new(valid_project_fields(options)); end
def create_project(options={}); (o = build_project(options)).save!; o; end

def valid_card_fields(options={})
  {
    :title    => 'card_title',
    :project  => options.keys.include?(:project) ? options[:project] : create_project,
  }.merge(options)
end
def mock_card(options={})
  mock_fields = {
    :timestamp      => Time.now,
    :title          => 'card title',
    :effort         => 1,
    :started_at     => Time.now,
    :started?       => true,
    :finished_at    => Time.now,
    :finished?      => true,
    :display_state  => 'started',
  }
  mock_model(Card, mock_fields)
end
def build_card(options={}); Card.new(valid_card_fields(options)); end
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

def mock_day(options={})
  mock_fields = {
    :timestamp                  => Time.now,
    :points_to_do               => 1,
    :points_done_all            => 1,
    :points_done_today          => 1,
    :speed_last_days            => 1,
    :speed_iteration            => 1,
    :speed_iteration_cumulated  => 1,
    :speed_overall              => 1,
  }
  mock_model(Day, mock_fields)
end