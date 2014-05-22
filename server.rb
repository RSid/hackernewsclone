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

@desc=""

###

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

    #get this into a persisted file
      CSV.open("articles.csv","a") do |csv|
        csv<<[@title,@url,@description]
      end
      redirect "/"

  end


end
