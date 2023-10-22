# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem "activerecord"
  gem "bunny"
  gem "faker"
  gem "sqlite3"
end

require "active_record"
require "minitest/autorun"
require "logger"
require "faker"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :warehouses, force: true do |t|
    t.string :location
  end

  create_table :products, force: true do |t|
    t.string :sku
    t.string :name
    t.float :price
  end

  create_table :customers, force: true do |t|
    t.string :name
    t.string :email
    t.string :location
  end

  create_table :stock_items, force: true do |t|
    t.integer :warehouse_id
    t.integer :product_id
    t.integer :quantity
    t.integer :restock_level
  end

  create_table :line_items, force: true do |t|
    t.integer :order_id
    t.integer :product_id
    t.integer :quantity
  end 

  create_table :orders, force: true do |t|
    t.integer :customer_id
    t.boolean :delivered, default: false
  end 

  create_table :shipments, force: true do |t|
    t.integer :customer_id
    t.integer :order_id
    t.integer :warehouse_id
  end 
end

class Warehouse < ActiveRecord::Base
  has_many :stock_items
  has_many :shipments
end

class Product < ActiveRecord::Base
  has_many :stock_items
  has_many :line_items
end

class Customer < ActiveRecord::Base
  has_many :orders
  has_many :shipments
end

class StockItem < ActiveRecord::Base
  belongs_to :warehouse 
  belongs_to :product
end

class LineItem < ActiveRecord::Base
  belongs_to :product 
  belongs_to :order
end

class Order < ActiveRecord::Base
  belongs_to :customer
  has_many :line_items
  has_many :shipments
end

class Shipment < ActiveRecord::Base
  belongs_to :customer 
  belongs_to :order
  belongs_to :warehouse
end



# SecureRandom.uuid
# Faker::Commerce.product_name #=> "Practical Granite Shirt"
# Faker::Commerce.price #=> 44.6
# Faker::Nation.capital_city #=> "Kathmandu"
# Faker::Name.name 
# Faker::Internet.free_email(name: 'Nancy')



# class BugTest < Minitest::Test
#   def test_association_stuff
#     post = Post.create!
#     post.comments << Comment.create!

#     assert_equal 1, post.comments.count
#     assert_equal 1, Comment.count
#     assert_equal post.id, Comment.first.post.id
#   end
# end