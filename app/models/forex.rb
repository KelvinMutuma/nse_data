# == Schema Information
#
# Table name: forexes
#
#  id           :integer          not null, primary key
#  currency     :string(255)
#  buy          :float
#  sell         :float
#  mean         :float
#  created_at   :datetime
#  updated_at   :datetime
#  guid         :string(255)
#  published_at :datetime
#

class Forex < ActiveRecord::Base
	feed_url = "https://spreadsheets.google.com/feeds/list/1KsgFX_MtJLqDcOs8fcV4HLZ_gAKlU0NMQviEAl5Ar4M/od6/public/values"
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
        # anydate = b.scan(/\d{4}\/\d{2}\/\d{2}/)
        # if !anydate.empty?
        #   anydate.each {|s| b = b.gsub(s,'0').gsub(",",".")}
        # else
        #   b = b.gsub(",",".")
        # end
        content = b.scan(/(?<=[ *])-?\d[\d.]+/).map(&:to_f)
        #contents = entry.content.split(',').map {|n| n.split(" ").last }

        #parsed_contents = contents.map{ |x| x.scan(/[\d\.-]+/)[0] }.map(&:to_f)
        Forex.create!(
          currency: content[0],
          buy: content[1],
          sell: content[2],
          percentage_change: content[3],
          high: content[4],
          low: content[5],
          published_at: entry.updated,
          guid: entry.id+c
        );
      end			  
  	end
  end
end
