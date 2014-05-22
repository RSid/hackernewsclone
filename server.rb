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



###

get '/' do
  @articles_info=get_articles('articles.csv')

  erb :index
end

get '/submit' do

  erb :submit
end


post "/submit" do
  body=params["body"]
  title=params["title"]
  #get this into a persisted file
  redirect "/submit"
end
