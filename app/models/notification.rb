class Notification < ActiveRecord::Base
  attr_accessible :description, :lat, :lon, :title
  attr_accessor :current_server_timestamp

  def current_server_timestamp
    @current_server_timestamp = DateTime.now()
  end

  def attributes
    res = super
    res["current_server_timestamp"] = self.current_server_timestamp

    res
  end

  def vote_up
    self.votes_up += 1
    self.save
  end

  def self.all_since(since_timestamp = '00000')
    since_timestamp = Time.parse(since_timestamp)

    self.where('updated_at > ?', since_timestamp)
  end
end
