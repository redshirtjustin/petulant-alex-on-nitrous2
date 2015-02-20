require 'rails_helper.rb'

RSpec.describe Section, type: :model do
    context "/ validation /" do
        before :each do
            @section = Section.new(title: "Business", description: "Business related news")            
        end
        
        it "is valid if there is a title and a description" do
            expect(@section).to be_valid
        end
        
        it "is invalid without a title" do
            @section.title = nil
            @section.valid?
            expect(@section.errors[:title]).to include "can't be blank" 
        end
        
        it "is invalid if title is more than 75 characters" do
            @section.title = Faker::Lorem.characters(76)
            @section.valid?
            expect(@section.errors[:title]).to include "is too long (maximum is 75 characters)"
        end

        it "is invalid without a description" do
            @section.description = nil
            @section.valid?
            expect(@section.errors[:description]).to include "can't be blank"
        end       
        
        it "is invalid if description is more than 140 characters" do
            @section.description = Faker::Lorem.characters(141)
            @section.valid?
            expect(@section.errors[:description]).to include "is too long (maximum is 140 characters)"
        end
    end
    
    context "/ data retrieval using instance methods /" do
        before :each do
            @section = Section.create(title: "Business", description: "Business related news")            
        end
        
        it "return the date that the section was created" do
            expect(@section.get_date_created).to eq @section.created_at
        end
        
        it "return the date that the section was last updated" do
            expect(@section.get_date_updated).to eq @section.updated_at
        end
        
        it "return the age (time from creation) in words" do
            expect(@section.age).to eq time_ago_in_words(@section.created_at)
        end
        
        it "return the freshness (time from last update) in words" do
            expect(@section.freshness).to eq time_ago_in_words(@section.created_at)
        end 
        
        it "return the title" do
            expect(@section.get_title).to eq "Business"
        end
        
        it "return the description" do
            expect(@section.get_description).to eq "Business related news" 
        end        
    end
    
    context "/ data setting using instance methods /" do
        before(:each) do
            @section = Section.create(title: "Business", description: "Business related news")            
        end
        
        it "set the title with set_title and save it to the database" do
            title = "Entertainment"
            @section.set_title(title)
            @section.reload
            expect(@section.title).to eq title
        end 
        
        it "set the description with set_description and save it to the database" do
            description = "Entertainment related news"
            @section.set_description(description)
            @section.reload
            expect(@section.description).to eq description
        end
    end
end