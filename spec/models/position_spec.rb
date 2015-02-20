require "rails_helper.rb"

RSpec.describe Position do
    context "/ validations /" do
        it "is valid if there is a story_id, element_id, element_type, position, and active" do 
            @position = Position.new(story_id: 1, element_id: 1, element_type: "QuoteContent",
                position: 1, active: true)
            expect(@position).to be_valid       
        end
    end
    
    context "/ data retrieval of creation and updation using instance methods /" do
        before :each do
            @position = Position.create(story_id: 1, element_id: 1, element_type: "QuoteContent",
                position: 1, active: true) 
        end
        
        it "returns the date that the position was created" do 
            expect(@position.get_date_created).to eq @position.created_at
        end
        
        it "returns the date that the position was last updated" do
            expect(@position.get_date_updated).to eq @position.updated_at
        end
        
        it "returns the age (time from creation) in words" do
            expect(@position.age).to eq time_ago_in_words(@position.created_at)
        end
        
        it "returns the freshness (time from last update) in words" do
            expect(@position.freshness).to eq time_ago_in_words(@position.created_at)
        end       
    end
    
    context "/ Active state instance methods /" do
        before :each do
            @position = Position.create(story_id: 1, element_id: 1, element_type: "QuoteContent",
                position: 1, active: true) 
        end
        
        it "asks if this position is active" do 
            expect(@position.is_active?).to be true
        end
        
        it "asks if this position is inactive" do 
            expect(@position.is_inactive?).to be false
        end
        
        it "sets and saves this position's active state to true" do 
            @position.active = nil
            @position.reload
            @position.activate
            expect(@position.is_active?).to eq true
        end
        
        it "sets and saves this position's active state to false" do 
            @position.active = nil
            @position.reload
            @position.inactivate
            expect(@position.is_inactive?).to eq true
        end
    end
    
    context "/ Position state instance methods /" do
        before :each do
            @position = Position.create(story_id: 1, element_id: 1, element_type: "QuoteContent",
                position: 1, active: true) 
        end
        
        it "returns the position of the Position" do 
            expect(@position.get_position).to eq @position.position
        end
        
        it "sets and saves the position" do
            expect(@position.get_position).to eq @position.position
            new_position = 2
            @position.set_position(new_position)
            expect(@position.get_position).to eq @position.position
        end
        
        it "decrements the position by 1 and saves to the db" do 
            @position.position = 2
            @position.bump_up
            @position.reload
            expect(@position.position).to eq 1
        end
        
        it "increments the position by 1 and saves to the db" do 
            @position.bump_down
            @position.reload
            expect(@position.position).to eq 2
        end
    end
    
    context "/ descriptive attributes getters and setters /" do
        before :each do
            @position = Position.create(story_id: 1, element_id: 1, element_type: "QuoteContent",
                position: 1, active: true) 
        end
        
        it "returns the position's owner id" do 
            expect(@position.get_owner).to eq @position.story_id
        end
        
        it "returns the position's element id" do 
            expect(@position.get_element_id).to eq @position.element_id
        end
        
        it "returns the position's element type" do 
            expect(@position.get_element_type).to eq @position.element_type
        end
        
        it "sets and saves a new owner" do
            @position.set_owner(2)
            @position.reload
            expect(@position.story_id).to eq 2
        end
        
        it "sets and saves the id and type of an new element for the position" do 
            element = SimpleContent.create(topic: Faker::Lorem.characters(140), content: Faker::Lorem.characters(255))
            @position.set_element(element)
            @position.reload
            expect(@position.element_id).to eq element.id
            expect(@position.element_type).to eq element.class.to_s
        end
    end
end