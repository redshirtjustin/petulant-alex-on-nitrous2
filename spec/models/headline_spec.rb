require "rails_helper"

RSpec.describe Headline, type: :model do    
    context "/ validation /" do
        it "is valid with content up to 140 characters" do
            @headline = Headline.new(content: Faker::Lorem.characters(140))
            @headline.valid?
            expect(@headline).to be_valid
        end
        
        it "is invalid if headline is more than 140 characters" do
            @headline = Headline.new(content: Faker::Lorem.characters(141))
            @headline.valid?
            expect(@headline.errors[:content]).to include "is too long (maximum is 140 characters)"
        end
        
        it "is invalid if headline has blank content" do
            @headline = Headline.new(content: "")
            @headline.valid?
            expect(@headline).to_not be_valid
        end
        
        it "is invalid with nil content" do
            @headline = Headline.new()
            @headline.valid?
            expect(@headline).to_not be_valid
        end
    end
    
    context "/ data retrieval using instance methods /" do
        before :each do
            @headline = Headline.create(story_id: 1, content: Faker::Lorem.characters(140))
        end
        
        it "returns the headline content" do
            expect(@headline.get_headline).to eq @headline.content
        end
        
        it "returns the id of the Story that this headline belongs to" do
            expect(@headline.get_owner).to eq @headline.story_id
        end
        
        it "returns the headline id" do
            expect(@headline.get_id).to eq @headline.id
        end     
        
        it "returns the date that the headline was created" do
            expect(@headline.get_date_created).to eq @headline.created_at
        end
        
        it "returns the date that the headline was last updated" do
            expect(@headline.get_date_updated).to eq @headline.updated_at
        end
        
        it "returns the age (time from creation) in words" do
            expect(@headline.age).to eq time_ago_in_words(@headline.created_at)
        end
        
        it "returns the freshness (time from last update) in words" do
            expect(@headline.freshness).to eq time_ago_in_words(@headline.created_at)
        end  
    end
    
    context "/ data setting using instance methods /" do
        before :each do
            @headline = Headline.create(content: Faker::Lorem.characters(140))
        end
        
        it "runs set_headline('..') and should set a new headline" do
            @headline.set_headline("Fantastic new apps being built daily.")
            @headline.reload
            expect(@headline.content).to eq "Fantastic new apps being built daily."
        end
        
        it "runs set_owner and should set a new owner id" do
            new_owner_id = 100
            @headline.set_owner(new_owner_id)
            @headline.reload
            expect(@headline.get_owner).to eq new_owner_id
        end
    end
end
