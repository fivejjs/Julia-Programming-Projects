module Articles

export Article, save, find

using ...Database, MySQL, JSON

struct Article
  content::String
  links::Vector{String}
  title::String
  image::String
  url::String

  Article(; content = "", links = String[], title = "", image = "", url = "") =
    new(content, links, title, image, url)
  Article(content, links, title, image, url) =
    new(content, links, title, image, url)
end

function find(url)::Vector{Article}
  articles = Article[]

  result =
    DBInterface.execute(CONN, "SELECT * FROM `articles` WHERE url = '$url'")

  isempty(result) && return articles

  # for i in eachindex(result)
  #   push!(articles, Article(result.content[i],
  #                           JSON.parse(result.links[i]),
  #                           result.title[i],
  #                           result.image[i],
  #                           result.url[i]))
  # end
  for r in result
    push!(
      articles,
      Article(r.content, JSON.parse(r.links), r.title, r.image, r.url),
    )
  end
  articles
end

function save(a::Article)
  sql = "INSERT IGNORE INTO articles
            (title, content, links, image, url) VALUES (?, ?, ?, ?, ?)"
  # stmt = MySQL.Stmt(CONN, sql)
  stmt = DBInterface.prepare(CONN, sql)
  result = DBInterface.execute(
    stmt,
    [a.title, a.content, JSON.json(a.links), a.image, a.url],
  )
end

function createtable()
  sql = """
    CREATE TABLE `articles` (
      `title` varchar(1000),
      `content` text,
      `links` text,
      `image` varchar(500),
      `url` varchar(500),
      UNIQUE KEY `url` (`url`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8
  """

  DBInterface.execute(CONN, sql)
end

end
