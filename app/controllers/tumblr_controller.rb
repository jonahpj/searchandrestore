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

end

