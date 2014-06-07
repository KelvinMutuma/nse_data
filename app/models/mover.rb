# == Schema Information
#
# Table name: movers
#
#  id           :integer          not null, primary key
#  mover        :string(255)
#  volume       :integer
#  created_at   :datetime
#  updated_at   :datetime
#  guid         :string(255)
#  published_at :datetime
#

class Mover < ActiveRecord::Base
	 feed_url = "https://spreadsheets.google.com/feeds/list/1hb9O9MulweXASHaRzYbIOpRpkT7Mksx5xayfsUtv_8g/od6/public/values"
	def update_from_feed(feed_url)
	  feed = Feedjira::Feed.fetch_and_parse(feed_url)
    # unless feed.is_a?(Fixnum)
    #   add_entries(feed.entries)
    # else
    #   puts feed.inspect
    # end
	end

  def self.update_from_feed_continuously(feed_url,delay_interval=2.minutes)
  	feed = Feedjira::Feed.fetch_and_parse(feed_url)
  	add_entries(feed.entries)

  	loop do
  		sleep delay_interval
  		feed = Feedjira::Feed.update(feed_url)
  		add_entries(feed.new_entries) if feed.updated?
  	end
  end

  private


  def self.add_entries(entries)
  	entries.each do | entry |
      c = entry.updated.to_s
      unless exists? guid: entry.id+c
        b = entry.content
        content = b.scan(/(?<=[ *])-?\d[\d.]+/).map(&:to_f)
        Mover.create!(
          mover: content[0],
          volume: content[1],
          published_at: entry.updated,
          guid: entry.id+c
        );
      end			  
  	end
  end
end
