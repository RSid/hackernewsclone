require 'sinatra'
require 'shotgun'
require 'CSV'
require 'pry'


def get_articles (file_name)
  @all_articles=[]

  CSV.foreach(file_name, :headers => true) do |row|
    title=row["title"]
    url=row["url"]
    description=row["description"]


    @all_articles.push( {:Title => title, :URL => url, :Description => description} )
  end
  @all_articles
end

def is_repeat (file_name,array)

 articles = CSV.read(file_name)
 is_there = false

 articles.each do |article_entry|
    if article_entry.join(",")==array.join(",")
      is_there = true
    end
 end
 is_there

end

#server call logic below

get '/' do
  @articles_info=get_articles('articles.csv')

  erb :index
end

get '/submit' do

  erb :submit
end


post "/submit" do
  @title=params["title"]
  @url=params["url"]
  @description=params["description"]


  if @title == "" || @description == "" || @url == ""
    @message="Not a valid submission. Please include a title, url, and description."
    erb :submit
  else
    article_info=[@title,@url,@description]

    if is_repeat('articles.csv',article_info)==true
      @message="Article already submitted. You are not original."
      erb :submit
    else
      #gets this into a persisted file
        CSV.open("articles.csv","a") do |csv|
          csv<<article_info
        end
        redirect "/"
    end

  end


end
