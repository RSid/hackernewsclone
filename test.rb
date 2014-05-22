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
    @urls_v<<article_info[:URL]
  end
  @urls_v
end


def check_if_repeat (file_name,array)

 articles = CSV.read(file_name)
 is_there = false

 articles.each do |article_entry|
    if article_entry.join(",")==array.join(",")
      is_there = true
    end
 end
 is_there

end


#print get_articles('articles.csv')
print check_if_repeat('articles.csv',['Article','www.bo.com','Cool stuff'])
