require 'CSV'
require 'pry'
require 'redis'
require 'json'


def get_connection
  if ENV.has_key?("REDISCLOUD_URL")
    Redis.new(url: ENV["REDISCLOUD_URL"])
  else
    Redis.new
  end
end


def find_articles
  redis = get_connection
  serialized_articles = redis.lrange("slacker:articles", 0, -1)

  articles = []

  serialized_articles.each do |article|
    articles << JSON.parse(article, symbolize_names: true)
  end

  articles
end


def save_article(url, title, description)
  article = { url: url, title: title, description: description }

  redis = get_connection
  redis.rpush("slacker:articles", article.to_json)
end

def delete_article(url, title, description)
  article = { url: url, title: title, description: description }

  redis = get_connection
  redis.rdel(article)
end

get_connection

#save_article('bee.com','Bee','bbgun')
delete_article('bee.com','Bee','bbgun')

print find_articles
