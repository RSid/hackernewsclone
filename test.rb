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


def article_titles (file_name)
  @all_articles=get_articles(file_name)

  @titles=[]

  @all_articles.each do |article_info|
    @titles<<article_info[:Title]
  end
  @titles
end

def article_urls_verbose (file_name)
  @all_articles=get_articles(file_name)
  @urls_v=[]

  @all_articles.each do |article_info|
    @urls<<article_info[:URL]
  end
  @urls_v
end



print article_urls('articles.csv')
