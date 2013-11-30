# my_app.rb
require 'sinatra'
require 'yaml'

class MyApp < Sinatra::Base

  before do 
    @posts = Dir.glob("views/posts/*.erb").map do |post_name|
      post_name.split("/").last.slice(0..-5)
    end
    @sorted_posts = meta_data.sort_by {|post, date_hash| date_hash["date"] }.reverse
  end

  get "/" do
    erb :index
  end

  get "/blog/:post_name" do
    html = erb("posts/#{params[:post_name]}".to_sym, layout: false,)
    html = html.split("\n\n", 2).last
    erb html
  end

  def meta_data
    if @meta_data
      @meta_data
    else
      @meta_data = {}
      @posts.each do |post|
        html = erb("/posts/#{post}".to_sym, layout: false)
        meta = YAML.load(html.split("\n\n", 2).first)
        @meta_data[post] = meta
      end
      @meta_data
    end
  end
end