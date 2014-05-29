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

def is_repeat (url)

 db_connection do |conn|
    conn.exec('SELECT url FROM slacker_articles WHERE url=' + url).values
  end
end



def find_all_comments
  db_connection do |conn|
    conn.exec('SELECT * FROM comments').values
  end
end

def find_comments(id)
  db_connection do |conn|
    conn.exec_params('SELECT * FROM comments WHERE article_id= $1',[id]).values
  end
end



def save_comments(user,article_id,comment,time_posted)
  db_connection do |conn|
    conn.exec_params('INSERT INTO comments (posted_by, article_id,comment,created_at) VALUES ($1,$2,$3,$4)',[user,article_id,comment,time_posted])
  end
end



def is_good_url (string)
  (string.include? "http://") || (string.include? "https://")
end

############################
#CONTROLLERS BELOW
############################

get '/' do
  @articles_info=find_articles()

  erb :index
end

get '/articles/new' do

  erb :submit
end


post "/articles/new" do
  @title=params["title"]
  @url=params["url"]
  @description=params["description"]

  if @title == "" || @description == "" || @url == "" || @description.length<20 || is_good_url(@url)==false
    @message="Not a valid submission. Please include a title, valid url, and description of 20 or more characters."
    erb :submit
  elsif is_repeat(("'" + @url + "'")).flatten[0]==@url

    @message="Article already submitted. You are not original."
    erb :submit
  else
    save_article(@url,@title,@description)

    redirect "/"
  end

end

get '/articles/:id/comments' do
  @article_id=params[:id]

  @articles_info=find_articles()

  @comments=find_comments(@article_id)

  erb :comments
end

post '/articles/:id/comments' do
  @article_id=params[:id]

  @user=params["user"]
  @comment=params["comment"]

  if @user == "" || @comment == "" || @comment.length<5
    @message="Please include a username and a comment longer than 5 characters."
    erb :comments
  else
    save_comments(@user,@article_id,@comment,Time.now)
    redirect "/articles/"+@article_id+"/comments"
  end

end
