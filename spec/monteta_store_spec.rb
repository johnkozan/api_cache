require File.dirname(__FILE__) + '/spec_helper'

require 'moneta'
require 'moneta/adapters/memcache'

describe APICache::MonetaStore do
  before :each do
    @moneta = Moneta::Builder.build do
      run Moneta::Adapters::Memcache, :server => "localhost"
    end
    @moneta.delete('foo')
    @store = APICache::MonetaStore.new(@moneta)
  end

  it "should set and get" do
    @store.set("key", "value")
    @store.get("key").should == "value"
  end

  it "should allow checking whether a key exists" do
    @store.exists?('foo').should be_false
    @store.set('foo', 'bar')
    @store.exists?('foo').should be_true
  end

  it "should allow checking whether a given amount of time has passed since the key was set" do
    @store.expired?('foo', 1).should be_false
    @store.set('foo', 'bar')
    @store.expired?('foo', 1).should be_false
    sleep 1
    @store.expired?('foo', 1).should be_true
  end
end
