class TumblrController < ApplicationController
  
require 'tumblr'

  def index
    
    Tumblr.blog = 'searchandrestore'
    @posts = Tumblr::Post.all
    
    @tabs = About.all

    @press_clippings = PressClipping.
      order('date DESC').
      includes(:link).
      limit(5)
    
  end
  
  def show

    @blog_posts = blog
    @blog_tags = []
    @blog_posts.each do |post|
      @blog_tags << blog_tags(post)
    end

     @tabs = About.all

     @press_clippings = PressClipping.
       order('date DESC').
       includes(:link).
       limit(5)

   end
  
   def blog
     uri = URI.parse('http://api.tumblr.com')
     api_key = 'vYYBosazRckPMQplWCdDEVryLs55FCmxHu3ZRr02C03ubfPI5H'
     id = params[:id]
     res = Net::HTTP.start(uri.host, uri.port) do |http|
       # todo: limit
       http.get('/v2/blog/searchandrestore.tumblr.com/posts?api_key=' + api_key + '&id=' + id)
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
end

