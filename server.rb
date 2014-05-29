require 'sinatra'
require 'shotgun'
require 'CSV'
require 'pry'
require 'pg'
require 'json'


def db_connection
  begin
    connection = PG.connect(dbname: 'slacker_news')

    yield(connection)

  ensure
    connection.close
  end
end


def find_articles
  db_connection do |conn|
    conn.exec('SELECT * FROM slacker_articles').values
  end

end


def save_article(url, title, description)
  db_connection do |conn|
    conn.exec_params('INSERT INTO slacker_articles (url, title, description,created_at) VALUES ($1,$2,$3,now())',[url,title,description])
  end

end



def is_good_url (string)
  (string.include? ".com") || (string.include? ".net") || (string.include? ".gov") || (string.include? ".io") || (string.include? ".org")
end

############################
#CONTROLLERS BELOW
############################

get '/' do
  @articles_info=find_articles()

  erb :index
end

get '/submit' do

  erb :submit
end


post "/submit" do
  @title=params["title"]
  @url=params["url"]
  @description=params["description"]


  if @title == "" || @description == "" || @url == "" || @description.length<20 #|| is_good_url(@url)==false
    @message="Not a valid submission. Please include a title, valid url, and description of 20 or more characters."
    erb :submit
  else
    save_article(@url,@title,@description)

   redirect "/"

  end


end
