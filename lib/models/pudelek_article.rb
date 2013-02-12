require File.expand_path('pudelek_article_page', File.dirname(__FILE__))

module PudelekRSSFeed
  class PudelekArticle

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

    def time
      @time || article_page.time || Time.now
    end

    def content
      article_page.content
    end

    def article_id
      article_page.article_id
    end

    def to_hash
      {
          :url => url,
          :title => title,
          :time => time,
          :article_id => article_id,
          :content => content
      }
    end

    private

    def article_page
      @article_page ||= PudelekArticlePage.from_url(url)
    end

  end
end