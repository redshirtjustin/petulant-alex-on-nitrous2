require "rails_helper"

RSpec.describe Leadline, type: :model do    
    context "validation:" do
        it "/ is valid with content up to 555 characters /" do
            @leadline = Leadline.new(content: Faker::Lorem.characters(555))
            @leadline.valid?
            expect(@leadline).to be_valid
        end
        
        it "is invalid if leadline is more than 556 characters" do
            @leadline = Leadline.new(content: Faker::Lorem.characters(556))
            @leadline.valid?
            expect(@leadline.errors[:content]).to include "is too long (maximum is 555 characters)"
        end
        
        it "is invalid if leadline has blank content" do
            @leadline = Leadline.new(content: "")
            @leadline.valid?
            expect(@leadline).to_not be_valid
        end
        
        it "is invalid with nil content" do
            @leadline = Leadline.new()
            @leadline.valid?
            expect(@leadline).to_not be_valid
        end
    end
    
    context "/ data retrieval using instance methods /" do
        before :each do
            @leadline = Leadline.create(content: Faker::Lorem.characters(140))
        end
        
        it "returns the leadline content" do
            expect(@leadline.get_leadline).to eq @leadline.content
        end
        
        it "returns the id of the Story that this leadline belongs to" do
            expect(@leadline.get_owner).to eq @leadline.story_id
        end
        
        it "returns the leadline id" do
            expect(@leadline.get_id).to eq @leadline.id
        end     
        
        it "returns the date that the leadline was created" do
            expect(@leadline.get_date_created).to eq @leadline.created_at
        end
        
        it "returns the date that the leadline was last updated" do
            expect(@leadline.get_date_updated).to eq @leadline.updated_at
        end
        
        it "returns the age (time from creation) in words" do
            expect(@leadline.age).to eq time_ago_in_words(@leadline.created_at)
        end
        
        it "returns the freshness (time from last update) in words" do
            expect(@leadline.freshness).to eq time_ago_in_words(@leadline.created_at)
        end  
    end
    
    context "/ data setting using instance methods /" do
        before :each do
            @leadline = Leadline.create(content: Faker::Lorem.characters(140))
        end
        
        it "runs set_leadline('..') and should set a new leadline" do
            @leadline.set_leadline("Fantastic new apps being built daily.")
            @leadline.reload
            expect(@leadline.content).to eq "Fantastic new apps being built daily."
        end
        
        it "runs set_owner and should set a new owner id" do
            new_owner_id = 100
            @leadline.set_owner(new_owner_id)
            @leadline.reload
            expect(@leadline.get_owner).to eq new_owner_id
        end
    end
end
