require 'spec_helper'

describe PudelekRSSFeed::PudelekArticle do
  let(:article_time) {Time.at(1234567890)}
  subject do
    PudelekRSSFeed::PudelekArticle.from_params(
        :url => 'http://pudelek.pl/artykul/12345',
        :title => 'some title',
        :time => article_time
    )
  end

  before do
    article_page = mock(:article_page,
                        :time => Time.at(1234568890),
                        :article_id => 'http://pudelek.pl/artykul/12345',
                        :content => 'some content')
    PudelekRSSFeed::PudelekArticlePage.stub(:from_url).and_return(article_page)
  end

  describe "#time" do
    it "should return the time provided in init params" do
      subject.time.should == Time.new(2009, 2, 14, 10, 31, 30, "+11:00")
    end
    context "time not provided in init params" do
      let(:article_time) {nil}
      it "should return the time from the article page" do
        subject.time.should == Time.new(2009, 2, 14, 10, 48, 10, "+11:00")
      end

    end
  end

  describe "comparing" do
    it "should compare to an other article by the time" do
      greater = PudelekRSSFeed::PudelekArticle.from_params(:time => Time.at(1234567895))
      (subject < greater).should be_true
      lower = PudelekRSSFeed::PudelekArticle.from_params(:time => Time.at(1234567880))
      (subject > lower).should be_true
      equal = PudelekRSSFeed::PudelekArticle.from_params(:time => Time.at(1234567890))
      subject.should == equal
    end
  end

  its(:content) {should == 'some content'}
  its(:article_id) {should == 'http://pudelek.pl/artykul/12345'}
end