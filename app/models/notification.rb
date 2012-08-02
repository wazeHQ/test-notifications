class Notification < ActiveRecord::Base
  attr_accessible :created_by, :description, :is_active, :lat, :lon, :title, :votes_up
end
