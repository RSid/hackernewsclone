CREATE TABLE slacker_articles (
  id serial PRIMARY KEY,
  url varchar(1000) NOT NULL,
  title varchar(500) NOT NULL,
  description varchar(600) NOT NULL,
  created_at timestamp

);

CREATE TABLE comments (
  id serial PRIMARY KEY,
  posted_by varchar(30) NOT NULL,
  article_id integer NOT NULL,
  comment varchar(2000) NOT NULL

);
