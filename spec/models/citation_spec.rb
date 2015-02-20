require "rails_helper"
include ActionView::Helpers

RSpec.describe Citation, type: :model do
    context "/ validation /" do        
        before(:each) do
            @citation = Citation.create(title: Faker::Company.name, url: Faker::Internet.url)
        end

        it "is valid with a title and a formated url" do
            expect(@citation).to be_valid
        end

        it "is invalid without a title" do
            @citation.title = nil
            @citation.valid?
            expect(@citation.errors[:title]).to include "can't be blank" 
        end
        
        it "is invalid if title is more than 140 characters" do
            @citation.title = Faker::Lorem.characters(141)
            @citation.valid?
            expect(@citation.errors[:title]).to include "is too long (maximum is 140 characters)"
        end

        it "is invalid without a url" do
            @citation.url = nil
            @citation.valid?
            expect(@citation.errors[:url]).to include "can't be blank"
        end
        
        it "is invalid with an improperly formatted url" do
            @citation.url = "htt://www.wordpress"
            @citation.valid?
            expect(@citation.errors[:url]).to include "is invalid"
        end
    end
        
    context "/ data retrieval using instance methods /" do
        before(:each) do
            @citation = Citation.create(title: Faker::Company.name, url: Faker::Internet.url)
        end

        it "returns the date that the citation was created" do
            expect(@citation.get_date_created).to eq @citation.created_at
        end
        
        it "returns the date that the citation was last updated" do
            expect(@citation.get_date_updated).to eq @citation.updated_at
        end
        
        it "returns the age (time from creation) in words" do
            expect(@citation.age).to eq time_ago_in_words(@citation.created_at)
        end
        
        it "returns the freshness (time from last update) in words" do
            expect(@citation.freshness).to eq time_ago_in_words(@citation.created_at)
        end        
        
        it "returns the title of the citation website" do
            expect(@citation.get_cite_title).to eq @citation.title
        end
        
        it "returns the url of the citation website" do
            expect(@citation.get_cite_url).to eq @citation.url 
        end
    end
    
    context "/ data setting using instance methods /" do
        before(:each) do
            @citation = Citation.create(title: Faker::Company.name, url: Faker::Internet.url)
        end
        
        it "run set_cite_title('Happy new title saved!')" do
            @citation.set_cite_title("Happy new title saved!")
            @citation.reload
            expect(@citation.title).to eq "Happy new title saved!"
        end 
        
        it "run set_cite_url(random url)" do
            url = Faker::Internet.url
            @citation.set_cite_url(url)
            @citation.reload
            expect(@citation.title).to eq url
        end
    end
end