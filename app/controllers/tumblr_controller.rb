class TumblrController < ApplicationController
require 'net/http'  
require "html_truncator"



  def index 
      @blog_posts = blog
      @blog_tags = []
      @blog_posts.each do |post|
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
    offset = "1"
    if params[:id].present?
      id = params[:id]
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.get('/v2/blog/searchandrestore.tumblr.com/posts?api_key=' + api_key + '&id=' + id)
      end
    elsif params[:tag].present?
      if params[:page].present?
        tag = params[:tag]
        page = params[:page]
        $page = page.to_i
        $offset = $page*5-4
        offset = $offset.to_s
        res = Net::HTTP.start(uri.host, uri.port) do |http|
          http.get('/v2/blog/searchandrestore.tumblr.com/posts?api_key=' + api_key + '&limit=5&offset=' + offset + '&tag=' + tag)      
        end
      else
        tag = params[:tag]
        res = Net::HTTP.start(uri.host, uri.port) do |http|
          http.get('/v2/blog/searchandrestore.tumblr.com/posts?api_key=' + api_key + '&limit=5&tag=' + tag)
        end
      end
    elsif params[:page].present?
      page = params[:page]
      $page = page.to_i
      $offset = $page*5-4
      offset = $offset.to_s
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.get('/v2/blog/searchandrestore.tumblr.com/posts?api_key=' + api_key + '&limit=5&offset=' + offset)      
      end
    elsif params[:tag].present?
      tag = params[:tag]
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.get('/v2/blog/searchandrestore.tumblr.com/posts?api_key=' + api_key + '&limit=5&tag=' + tag)
      end
    else
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.get('/v2/blog/searchandrestore.tumblr.com/posts?api_key=' + api_key + '&limit=5')
      end
    end
    json = JSON(res.body)
    json['response']['posts']
  end
  
  def show
    @blog_posts = sortedblog
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
   
   def sortedblog
      uri = URI.parse('http://api.tumblr.com')
      api_key = 'vYYBosazRckPMQplWCdDEVryLs55FCmxHu3ZRr02C03ubfPI5H'
      parameter = params[:p]
      request = params[:r]
      sort = parameter + "=" + request
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.get('/v2/blog/searchandrestore.tumblr.com/posts?api_key=' + api_key + '&' + sort + '&limit=5')
      end
      json = JSON(res.body)
      json['response']['posts']
    end
   
   def legacy
     @blog_posts = legacyblog.paginate(:page => params[:page], :per_page => 5)
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
   
   def legacyblog
      uri = URI.parse('http://api.tumblr.com')
      api_key = 'vYYBosazRckPMQplWCdDEVryLs55FCmxHu3ZRr02C03ubfPI5H'
      id = params[:id]
      res = Net::HTTP.start(uri.host, uri.port) do |http|
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

