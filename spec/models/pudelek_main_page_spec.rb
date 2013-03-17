require 'spec_helper'

describe PudelekRSSFeed::PudelekMainPage do
  let(:html) {File.read(File.join(File.dirname(__FILE__), '..', 'resources', 'main.html'))}
  subject do
    p = PudelekRSSFeed::PudelekMainPage.new
    p.stub(:fetch).and_return(html)
    p
  end

  describe "all" do
    it "should return all entries from the main page" do
      subject.all.size.should == 61
    end
  end

  describe "articles" do
    it "should return article/video entries from the main page" do
      subject.articles.size.should == 41
    end
  end

  describe "photo_stories" do
    it "should return photo entries from the main page" do
      subject.photo_stories.size.should == 20
    end
  end
end