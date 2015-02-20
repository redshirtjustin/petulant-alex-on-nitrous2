require 'rails_helper.rb'

RSpec.describe SimpleContent, type: :model do
    context "/ validation /" do
        before :each do
            @simple = SimpleContent.new(topic: "Topics quickly describe the content.", content: Faker::Lorem.characters(555))            
        end
        
        it "is valid if both topic and content are present" do
            expect(@simple).to be_valid
        end
                
        it "is invalid without content" do
            @simple.content = nil
            @simple.valid?
            expect(@simple.errors[:content]).to include "can't be blank" 
        end
        
        it "is invalid without a topic" do
            @simple.topic = nil
            @simple.valid?
            expect(@simple.errors[:topic]).to include "can't be blank"
        end

        it "is invalid if topic is more than 140 characters" do
            @simple.topic = Faker::Lorem.characters(141)
            @simple.valid?
            expect(@simple.errors[:topic]).to include "is too long (maximum is 140 characters)"
        end
        
        it "is invalid if content is more than 555 characters" do
            @simple.content = Faker::Lorem.characters(556)
            @simple.valid?
            expect(@simple.errors[:content]).to include "is too long (maximum is 555 characters)"
        end
    end
    
    context "/ data retrieval using instance methods /" do
        before(:each) do
            @simple = SimpleContent.create(topic: "Topics quickly describe the content.", content: Faker::Lorem.characters(555))
        end

        it "returns the date that the simple was created" do
            expect(@simple.get_date_created).to eq @simple.created_at
        end
        
        it "returns the date that the simple was last updated" do
            expect(@simple.get_date_updated).to eq @simple.updated_at
        end
        
        it "returns the age (time from creation) in words" do
            expect(@simple.age).to eq time_ago_in_words(@simple.created_at)
        end
        
        it "returns the freshness (time from last update) in words" do
            expect(@simple.freshness).to eq time_ago_in_words(@simple.created_at)
        end
        
        it "returns the content of the element" do    
            expect(@simple.get_content).to eq @simple.content
        end
        
        it "returns the topic of the element" do
            expect(@simple.get_topic).to eq @simple.topic
        end    
    end
    
    context "/ data setting using instance methods /" do
        before(:each) do
            @simple = SimpleContent.create(topic: "Topics quickly describe the content.", content: Faker::Lorem.characters(555))
        end
        
        it "sets the topic and saves it to the database" do
            topic = "A new topic"
            @simple.set_topic(topic)
            @simple.reload
            expect(@simple.topic).to eq topic
        end
        
        it "sets the content and saves it to the database" do
            content = "Some new content"
            @simple.set_content(content)
            @simple.reload
            expect(@simple.content).to eq content
        end
    end
end