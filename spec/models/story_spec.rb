require 'rails_helper'
include ActionView::Helpers

RSpec.describe Story do
    context "/ validation /" do 
        before :each do
            @story = Story.new(subject: "Story subject.", section_id: 1)
        end
        
        it "is invalid without a subject and section" do
            @story = Story.new()
            expect(@story).to be_invalid
        end
        
        it "is invalid without a subject but with section" do
            @story.subject = nil
            expect(@story).to be_invalid
        end
        
        it "is invalid without a section but with a subject" do
            @story.section_id = nil
            expect(@story).to be_invalid
        end
        
        it "is valid with a subject and section" do
            expect(@story).to be_valid
        end
    end
    
    context "/ creation, age, and freshness methods /" do
        before :each do
            @story = Story.create!(subject: "Story subject.", section_id: 1)
        end
        
        it "returns the date that the story was created" do 
            expect(@story.get_date_created).to eq @story.created_at
        end
        it "returns the date the story was last updated" do 
            expect(@story.get_date_updated).to eq @story.updated_at
        end
        it "returns the age of the story" do 
            expect(@story.age).to eq time_ago_in_words(@story.created_at)
        end
        it "returns the freshness of the story" do 
            expect(@story.freshness).to eq time_ago_in_words(@story.updated_at)
        end
    end
    
    context "/ getters and setters of descriptive attributes /" do
        before :each do
            section = Section.create!(title: "Business", description: "Business news.")
            section = Section.create!(title: "Government and Politics", description: "News about politics.")
            @story = section.stories.create!(subject: "Story subject.", section_id: 1)
        end
        
        it "returns the subject of the story" do 
            expect(@story.get_subject).to eq @story.subject
        end
        it "returns the subject of the story using the alias 'about'" do 
            expect(@story.about).to eq @story.subject
        end
        it "returns the section title of the story" do 
            expect(@story.filed_under?).to eq @story.section.title
        end
        it "sets a new subject of the story and saves it" do 
            @story.set_subject("New subject for the story.")
            @story.reload
            expect(@story.get_subject).to eq @story.subject
        end
        it "sets a new section_id of the story and saves it" do 
            @story.set_section(2)
            @story.reload
            expect(@story.filed_under?).to eq @story.section.title
        end
    end
    
    context "/ active headline getter and setter methods /" do
        before :each do
            @story = Story.create!(subject: "Story subject.", section_id: 1, active_headline_id: 1, active_leadline_id: 1)
            @hl1 = @story.headlines.create!(content: "First headline.")
            @hl2 = @story.headlines.create!(content: "Second headline.")
            @hl3 = @story.headlines.create!(content: "Third headline.")
            @story.active_headline_id = @hl1.id
            @story.save!
            
            @hls = []
            @hls << @hl1
            @hls << @hl2
            @hls << @hl3
        end
        
        it "returns the active headline" do 
            expect(@story.get_active_headline).to eq @hl1.content
        end
        
        it "returns the active headline id" do 
            expect(@story.get_active_headline_id).to eq @hl1.id
        end
        
        it "returns the active headline age" do 
            expect(@story.active_headline_age).to eq time_ago_in_words(@hl1.created_at)
        end
        
        it "returns the active headline freshness" do 
            expect(@story.active_headline_freshness).to eq time_ago_in_words(@hl1.updated_at)
        end
        
        it "sets a new active headline" do 
            @story.set_active_headline(@hl2.id)
            @story.reload
            expect(@story.get_active_headline).to eq @hl2.content
        end
        
        it "create!s a new active headline" do 
            new_headline = "Fourth headline."
            @story.new_headline(new_headline, true)
            @story.reload
            expect(@story.get_active_headline).to eq new_headline
        end
        
        it "create!s a new inactive headline" do
            len = @story.headlines.size
            current_headline = @story.get_active_headline
            new_headline = "Fifth headline."

            @story.new_headline(new_headline, false)
            @story.reload
            expect(@story.headlines.size).to eq(len + 1)
            expect(@story.get_active_headline).to eq current_headline
        end
        
        it "returns headlines oldest to youngest" do 
            expect(@story.headlines_oldest_to_youngest).to match @hls
        end
        it "returns headlines youngest to oldest" do 
            expect(@story.headlines_youngest_to_oldest).to match @hls.reverse
        end
        it "returns the oldest headline" do 
            expect(@story.oldest_headline).to eq(@hl1.get_headline)
        end
        it "returns the youngest headline" do 
            expect(@story.youngest_headline).to eq(@hl3.get_headline)
        end
        it "returns the freshest headline" do 
            expect(@story.freshest_headline).to eq(@hl3.get_headline)
        end
        it "returns the stalest headline" do 
            expect(@story.stalest_headline).to eq(@hl1.get_headline)
        end
        it "returns headlines by freshness" do 
            expect(@story.headlines_by_freshness).to match @hls.reverse
        end
        it "returns headlines by stalest" do 
            expect(@story.headlines_by_staleness).to match @hls
        end        
    end
    
    context "/ active leadline getter and setter methods /" do
        before :each do
            @story = Story.create!(subject: "Story subject.", section_id: 1, active_leadline_id: 1, active_leadline_id: 1)
            @ll1 = @story.leadlines.create!(content: "First leadline.")
            @ll2 = @story.leadlines.create!(content: "Second leadline.")
            @ll3 = @story.leadlines.create!(content: "Third leadline.")
            @story.active_leadline_id = @ll1.id
            @story.save!
            
            @lls = []
            @lls << @ll1
            @lls << @ll2
            @lls << @ll3
        end
        
        it "returns the active leadline" do 
            expect(@story.get_active_leadline).to eq @ll1.content
        end
        
        it "returns the active leadline id" do 
            expect(@story.get_active_leadline_id).to eq @ll1.id
        end
        
        it "returns the active leadline age" do 
            expect(@story.active_leadline_age).to eq time_ago_in_words(@ll1.created_at)
        end
        
        it "returns the active leadline freshness" do 
            expect(@story.active_leadline_freshness).to eq time_ago_in_words(@ll1.updated_at)
        end
        
        it "sets a new active leadline" do 
            @story.set_active_leadline(@ll2.id)
            @story.reload
            expect(@story.get_active_leadline).to eq @ll2.content
        end
        
        it "create!s a new active leadline" do 
            new_leadline = "Fourth leadline."
            @story.new_leadline(new_leadline, true)
            @story.reload
            expect(@story.get_active_leadline).to eq new_leadline
        end
        
        it "create!s a new inactive leadline" do
            len = @story.leadlines.size
            current_leadline = @story.get_active_leadline
            new_leadline = "Fifth leadline."

            @story.new_leadline(new_leadline, false)
            @story.reload
            expect(@story.leadlines.size).to eq(len + 1)
            expect(@story.get_active_leadline).to eq current_leadline
        end
        
        it "returns leadlines oldest to youngest" do 
            expect(@story.leadlines_oldest_to_youngest).to match @lls
        end
        it "returns leadlines youngest to oldest" do 
            expect(@story.leadlines_youngest_to_oldest).to match @lls.reverse
        end
        it "returns the oldest leadline" do 
            expect(@story.oldest_leadline).to eq(@ll1.get_leadline)
        end
        it "returns the youngest leadline" do 
            expect(@story.youngest_leadline).to eq(@ll3.get_leadline)
        end
        it "returns the freshest leadline" do 
            expect(@story.freshest_leadline).to eq(@ll3.get_leadline)
        end
        it "returns the stalest leadline" do 
            expect(@story.stalest_leadline).to eq(@ll1.get_leadline)
        end
        it "returns leadlines by freshness" do 
            expect(@story.leadlines_by_freshness).to match @lls.reverse
        end
        it "returns leadlines by stalest" do 
            expect(@story.leadlines_by_staleness).to match @lls
        end        
    end
    
    context "/ pstack manipulations /" do 
        before :each do
            @story = Story.create!(subject: "Story subject.", section_id: 1, active_leadline_id: 1, active_leadline_id: 1)
            @mirror = []
            @end = 20
            for i in 1..@end do
                i > 10 ? activate = false : activate = true
                @mirror << @story.positions.create!(element_id: i, element_type: "SimpleContent", position: i, active: activate)
            end
         end
        
        it "returns the pstack forwards, order 1..n" do 
            expect(@story.get_pstack_forwards).to match @mirror
        end
        it "returns the pstack backwards, order n..1" do 
            expect(@story.get_pstack_backwards).to match @mirror.reverse
        end
        it "returns the active pstack forwards, order 1..n" do 
            expect(@story.get_active_pstack_forwards).to match @mirror.select { |p| p.active }

        end
        it "returns the active pstack backwards, order n..1" do 
            expect(@story.get_active_pstack_backwards).to match @mirror.select { |p| p.active }.reverse
        end
        it "returns the inactive pstack forwards, order 1..n" do 
            expect(@story.get_inactive_pstack_forwards).to match @mirror.select { |p| !p.active }

        end
        it "returns the inactive pstack backwards, order n..1" do 
            expect(@story.get_inactive_pstack_backwards).to match @mirror.select { |p| !p.active }.reverse
        end
        it "activates the pstack" do 
            @story.activate_pstack
            expect(@story.get_active_pstack_forwards.size).to eq @end
        end
        it "inactivates the pstack" do 
            @story.inactivate_pstack
            expect(@story.get_inactive_pstack_forwards.size).to eq @end
        end
        it "pstack order is consistent" do 
            expect(@story.is_pstack_consistent?).to be true
        end
        it "pstack order is not consistent" do
            # set some really high position: 400
            @story.positions.create!(element_id: 400, element_type: "SimpleContent", position: 400, active: true)
            expect(@story.is_pstack_consistent?).to be false
        end
        it "shifts all the positions in the pstack down by 1" do 
            pstack_key = @story.positions.order(position: :asc).pluck(:position)
            @story.shift
            @story.reload
            pstack_order = @story.positions.order(position: :asc).pluck(:position)
            expect(pstack_order.size).to eq pstack_key.size
            expect(pstack_order.last).to eq pstack_key.last + 1
            expect(pstack_order.first).to eq pstack_key.first + 1
        end
        it "shifts all the positions in the pstack up by 1" do 
            pstack_key = @story.positions.order(position: :asc).pluck(:position)
            @story.shift(-1)
            @story.reload
            pstack_order = @story.positions.order(position: :asc).pluck(:position)
            expect(pstack_order.size).to eq pstack_key.size
            expect(pstack_order.last).to eq pstack_key.last - 1
            expect(pstack_order.first).to eq pstack_key.first - 1
        end
        it "shifts all the positions in the pstack down by 10" do 
            pstack_key = @story.positions.order(position: :asc).pluck(:position)
            @story.shift(10)
            @story.reload
            pstack_order = @story.positions.order(position: :asc).pluck(:position)
            expect(pstack_order.size).to eq pstack_key.size
            expect(pstack_order.last).to eq pstack_key.last + 10
            expect(pstack_order.first).to eq pstack_key.first + 10
        end
        
        it "shifts all the positions in the pstack up by 10" do 
            pstack_key = @story.positions.order(position: :asc).pluck(:position)
            @story.shift(-10)
            @story.reload
            pstack_order = @story.positions.order(position: :asc).pluck(:position)
            expect(pstack_order.size).to eq pstack_key.size
            expect(pstack_order.last).to eq pstack_key.last - 10
            expect(pstack_order.first).to eq pstack_key.first - 10
        end
        
        it "makes an inconsistent pstack consistent" do
            # reset the @story pstack to some inconsistent pstack
            @story.positions.reverse.each do |p|
                p.position = p.position * 2
                p.save!
            end
            @story.make_pstack_consistent
            @story.reload
            expect(@story.is_pstack_consistent?).to be true            
        end
        
        it "trys to pop an empty pstack" do
            story_with_empty_pstack = Story.create!(subject: "Story subject.", section_id: 1, active_leadline_id: 1, active_leadline_id: 1)
            expect(story_with_empty_pstack.pop).to eq nil
        end
        
        it "destroys the last position in the pstack, does nothing to the referenced element" do 
            key_len = @story.positions.order(position: :asc).size 
            expect(@story.pop).to be true
            @story.reload
            expect(@story.positions.order(position: :asc).size).to eq key_len - 1
        end
        
        it "trys to chop and empty pstack" do
            story_with_empty_pstack = Story.create!(subject: "Story subject.", section_id: 1, active_leadline_id: 1, active_leadline_id: 1)
            expect(story_with_empty_pstack.chop).to eq nil
        end
        
        it "destroys the first position in the pstack, makes consistent, does nothing to the referenced element" do 
            key_len = @story.positions.order(position: :desc).size
            expect(@story.chop).to be true
            @story.reload
            expect(@story.positions.order(position: :desc).size).to eq key_len - 1
        end
        
        it "adds a position to the beginning of an empty pstack" do
            story_with_empty_pstack = Story.create!(subject: "Story subject.", section_id: 1, active_leadline_id: 1, active_leadline_id: 1)            
            key_len = story_with_empty_pstack.positions.order(position: :asc).size
            element = SimpleContent.create!(topic: Faker::Lorem.characters(100), content: Faker::Lorem.characters(255))
            
            story_with_empty_pstack.push(element)
            story_with_empty_pstack.reload
            expect(story_with_empty_pstack.positions.order(position: :asc).size).to eq key_len + 1
        end
        
        it "adds a position to the beginning of the pstack, and shifts the rest down 1" do 
            key_len = @story.positions.order(position: :desc).size
            element = SimpleContent.create!(topic: Faker::Lorem.characters(100), content: Faker::Lorem.characters(255))
            @story.push(element)
            @story.reload
            expect(@story.positions.order(position: :desc).size).to eq key_len + 1      
        end
        
        it "append a position to the end of and empty pstack" do
            story_with_empty_pstack = Story.create!(subject: "Story subject.", section_id: 1, active_leadline_id: 1, active_leadline_id: 1)
            key_len = story_with_empty_pstack.positions.order(position: :asc).size
            element = SimpleContent.create!(topic: Faker::Lorem.characters(100), content: Faker::Lorem.characters(255))
            
            story_with_empty_pstack.append(element)
            story_with_empty_pstack.reload
            expect(story_with_empty_pstack.positions.order(position: :asc).size).to eq key_len + 1
        end
        
        it "append a position to the end of a filled pstack" do
            key_len = @story.positions.order(position: :desc).size
            element = SimpleContent.create!(topic: Faker::Lorem.characters(100), content: Faker::Lorem.characters(255))
            @story.append(element)
            @story.reload
            expect(@story.positions.order(position: :desc).size).to eq key_len + 1             
        end
        
        
    context "given an ordered list of elements reset pstack to the new order /" do
        before :each do
            @story = Story.create!(subject: "Story subject.", section_id: 1, active_leadline_id: 1, active_leadline_id: 1)
            @mirror = []
            @a = []
            @end = 5
            for i in 1..@end do
                temp = @story.positions.create!(element_id: i, element_type: "SimpleContent", position: i, active: true)
                @mirror << temp
                @a << temp.id
            end
         end
        
        it "rejects setting the pstack by passing in too few elements" do 
            expect(@story.set_pstack_order(@a[0..3])).to be nil            
        end
        it "rejects setting the pstack with two many elements to reorder" do 
            # add one element too many to the array
            @a << 500
            expect(@story.set_pstack_order(@a)).to be nil
        end
        it "reorder pstack in reverse" do 
            @story.set_pstack_order(@a.reverse)
            expect(@story.get_pstack_forwards).to match @mirror.reverse
        end
        it "reorders given random reordering" do 
            @story.set_pstack_order(@a.shuffle)
            expect(@story.get_pstack_forwards).to_not match @mirror
        end
    end
    end
    
    context "/ content aggregation /" do
    end
end