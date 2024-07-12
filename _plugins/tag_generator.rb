module Jekyll
    class TagPageGenerator < Generator
      safe true
  
      def generate(site)
        if site.layouts.key? 'tag'
          dir = 'tag'
          site.tags.each do |tag, posts|
            paginate(site, dir, tag, posts)
          end
        end
      end
  
      def paginate(site, dir, tag, posts)
        per_page = site.config['paginate'] || 10
        num_pages = (posts.size / per_page.to_f).ceil
  
        (1..num_pages).each do |page|
          pager = Jekyll::Pager.new(site, page, posts, num_pages)
          page_path = page == 1 ? File.join(dir, tag) : File.join(dir, tag, "page#{page}")
  
          site.pages << TagPage.new(site, site.source, page_path, tag, pager)
        endㄴ
      end
    end
  
    class TagPage < Page
      def initialize(site, base, dir, tag, pager)
        @site = site
        @base = base
        @dir = dir
        @name = 'index.html'
  
        self.process(@name)
        self.read_yaml(File.join(base, '_layouts'), 'tag.html')
        self.data['tag'] = tag
        self.data['title'] = "Posts tagged \"#{tag}\""
        self.data['paginator'] = pager
      end
    end
  end