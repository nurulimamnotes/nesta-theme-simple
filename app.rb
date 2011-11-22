module Nesta
  class App
    use Rack::Static, :urls => ["/simple"], :root => "themes/simple/public"
    get '/robots.txt' do
      content_type 'text/plain', :charset => 'utf-8'
      <<-EOF
User-agent: *
Allow: /

Sitemap: http://www.nurulimam.com/sitemap.xml
EOF
    end
    
    get '/articles.xml' do
      content_type :xml, :charset => 'utf-8'
      set_from_config(:title, :subtitle, :author)
      @articles = Page.find_articles.select { |a| a.date }[0..9]
      cache haml(:atom, :format => :xhtml, :layout => false)
    end

    get '/sitemap.xml' do
      content_type :xml, :charset => 'utf-8'
      @pages = Page.find_all
      @last = @pages.map { |page| page.last_modified }.inject do |latest, page|
        (page > latest) ? page : latest
      end
      cache haml(:sitemap, :format => :xhtml, :layout => false)
    end

  end
end
