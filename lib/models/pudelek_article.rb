module PudelekRSSFeed
  class PudelekArticle
    include Comparable

    class << self

      def from_params(params)
        self.new(params)
      end

      protected :new
    end

    attr_reader :url, :title

    def initialize params
      @url = params[:url]
      @title = params[:title]
      @time = params[:time]
    end

    def <=> other
      time <=> other.time
    end

    def time
      @time || article_page.time || Time.now
    end

    def content
      article_page.content
    end

    def article_id
      article_page.article_id
    end

    private

    def article_page
      @article_page ||= PudelekArticlePage.from_url(url)
    end

  end
end

