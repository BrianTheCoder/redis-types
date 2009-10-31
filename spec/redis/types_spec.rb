require File.dirname(__FILE__) + '/../spec_helper.rb'
require 'redis/types'
require 'json'

describe Redis::Types do
  class Project
    include Redis::Types
    
    value :name
    value :created,     DateTime
    value :information, Json
    
    list :users,        Integer
    
    set :commits
  end
  
  class Commit
    include Redis::Types
    
    value :message
    value :created_at, EpochTime
  end
  
  %w(value list set).each do |method|
    it "should have a class level method of #{method}" do
      Project.should respond_to(method)
    end
  end
  
  it "should have an id" do
    p = Project.new
    p.should respond_to('id')
  end
  
  describe 'fields' do
    {
      :name => :value,
      :users => :list,
      :commits => :set
    }.each do |method, type|
      before{ @project = Project.new }
    
      it "defines a getter method for #{method}" do
        @project.should respond_to(method)
      end
    
      it "defines a setter method for #{method}" do
        @project.should respond_to("#{method}=")
      end
    
      it "defines a boolean method for #{method}" do
        @project.should respond_to("#{method}?")
      end
    
      it "should define the class accessor method" do
        @project.should respond_to("redis_#{type}_#{method}")
      end
    
      it "redis_#{type}_#{method} returns an instance Redis::#{type.to_s.capitalize}" do
        klass = Object.module_eval("Redis::#{type.to_s.capitalize}")
        @project.send(:"redis_#{type}_#{method}").should be_kind_of(klass)
      end
    
      it "sets the key #{method} in redis_fields" do
        Project.redis_fields.should have_key(method.to_s)
      end
    end
  
    it "should default to String type" do
      Project.redis_fields['name'].marshal.should be_kind_of(String)
    end
    
    describe 'a getter method' do
    end
    
    describe 'a setter method' do
    end
    
    describe 'a bool method' do
    end
  end
  
  
  it 'destroys a record' do
  end
end
