class HomeController < ApplicationController
  # todo: move this???
  require 'net/http'
  

  module Helpers
    extend ActionView::Helpers::TextHelper
  end

  before_filter :find_about, :only => [:index, :about]

  def index
    @homepage     = Homepage.last || 
      Homepage.new(:exciting_news => 'Add some exciting news dudes!')
    
    #if @homepage.well_hello_there.present?
    #  @well_hello_there = @homepage.well_hello_there
    #else
    #  @about        = About.last || 
    #    About.new(:about => 'Add some about text dudes!')

    #  @well_hello_there = Helpers.truncate(@about.about, :length => (@about.about.index('==<!-- homepage -->==') || 347) + 3)
    #end

    @top_picks    = Show.featured.today.limit(3)

    @featured_video = @homepage.video(:includes => [:show, { :performances => [:artist, :instrument] }])

    @featured_video ||= Video.
      order_by_show_date.
      includes(:show, { :performances => [:artist, :instrument] }).
      first

    @banners = HomepageBanner.order(random_function).all

    @featured_video_description = @homepage.video_description
    
    @blog_posts = blog
    @blog_tags = []
    @blog_posts.each do |post|
      @blog_tags << blog_tags(post)
    end
    
    @blog_banner = blog_banner
    
  end
  
  def index2
    index
  end

  def shows
    @uses_datepicker = true
  end

  def venues
    @uses_gmap = true
  end
  def venues_landing
    @uses_gmap = true
  end

  def video
    @has_video = true
  end

  def artists
    @has_video = true
  end

  def about
    @press_clippings = PressClipping.
      order('date DESC').
      includes(:link).
      limit(5)
  end
  
  def random_function
   	adapter = Rails.configuration.database_configuration[Rails.env]['adapter']
    if adapter == 'postgresql'
   	   rand_func = 'RANDOM()'
   	 else
   	   rand_func = 'RAND()'
   	 end
    rand_func	
  end

  def blog
    uri = URI.parse('http://api.tumblr.com')
    api_key = 'vYYBosazRckPMQplWCdDEVryLs55FCmxHu3ZRr02C03ubfPI5H'
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      # todo: limit
      http.get('/v2/blog/searchandrestore.tumblr.com/posts?api_key=' + api_key + '&limit=3')
    end
    json = JSON(res.body)
    json['response']['posts']
  end
  
  def blog_banner
     uri = URI.parse('http://api.tumblr.com')
     api_key = 'vYYBosazRckPMQplWCdDEVryLs55FCmxHu3ZRr02C03ubfPI5H'
     res = Net::HTTP.start(uri.host, uri.port) do |http|
       # todo: limit
       http.get('/v2/blog/searchandrestore.tumblr.com/posts?api_key=' + api_key + '&limit=1')
     end
     json = JSON(res.body)
     json['response']['posts']
   end
  
  def blog_tags(post)
    tags = {}
    post['tags'].each do |tag|
      tags[tag] = 'http://searchandrestore.tumblr.com/tagged' + tag.gsub(/ /, '-') 
    end
    tags
  end
  
  def random_function
    adapter = Rails.configuration.database_configuration[Rails.env]['adapter']
    if adapter == 'postgresql'
      rand_func = 'RANDOM()'
    else
      rand_func = 'RAND()'
    end
    rand_func
  end

  protected

    def find_about
      @about ||= (About.last || About.new(:about => 'Add some about dudes!'))
    end
end
