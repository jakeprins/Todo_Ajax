class Todo < ActiveRecord::Base
  validates_presence_of :title, on: :create
end
