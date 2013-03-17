require 'spec_helper'

describe PudelekRSSFeed::PudelekArticlePage do
  class EmptyCache
    class << self
      def retrieve(key)
        yield
      end
    end
  end

  let(:url) {'http://www.pudelek.pl/artykul/12345'}
  let(:html) {File.read(File.join(File.dirname(__FILE__),'..','resources','article.html'))}
  subject do
    p = PudelekRSSFeed::PudelekArticlePage.from_url(url)
    p.stub(:cache_class).and_return(EmptyCache)
    p.stub(:fetch).and_return(html)
    p
  end

  its(:time) {should == Time.new(2013, 2, 10, 10, 0, 0, "+11:00")}
  its(:article_id) {should == 'http://www.pudelek.pl/artykul/12345'}

  context "normal page" do
    its(:content) {should include('na Festiwalu w Berlinie!')}
    its(:video?) {should be_false}
  end

  context "video page" do
    let(:url) {'http://www.pudelek.tv/video/12345'}
    let(:html) {File.read(File.join(File.dirname(__FILE__),'..','resources','video.html'))}
    its(:content) {should include('W sieci zadebiutował właśnie się najnowszy teledysk')}
    its(:video?) {should be_true}
  end
end