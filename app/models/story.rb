##
# == Story Class
# A story object is a special container that has connecting headlines, leadlines, and story elements
# that are ordered in the 'Positions Stack' or pstack.
#
# === The idea in an English Nutshell
# It was intended that a story written about some news topic would best be consumed in index
# card size segments. The index cards (elements) would convey an unbiased fact about some aspect of
# the story. New cards could be added to the container/story as the topic developed.
#
# To facilitate this index card style story, there are some accompanying concepts.
#
# == Story Attributes
#
# Section - all stories belong to a single category
#
# Subject - the main topic of the story, limited to 140 characters
#
# Active Headline - A story can own an increasing number of headlines, so as the story develops new
# 				headlines can capture the developing facts. Also, when displayed in chronological 
# 				fashion, the headlines will read like a developing story timeline. There are a few
# 				methods that work with the active headline, and there are a few methods that return
# 				the chronology of the headlines.
#
# 				There are not a lot of delete features because stories should be treated not as 
# 				in drafts, but rather an organic developing topic, it is preferred that authors
# 				make inactive headlines, leadlines, and elements rather than delete, for posterity.
#
# Active Leadline - See Active Headline.. difference: Leadlines are limited to 555 characters.
#
# == Story elements
#
# Currently there are only two elements. SimpleContent and QuoteContent
#
# Elements compose the majority of content displayed in a story. Each class of element tackles a
# particular focus. 
#
# SimpleContent - Should focus on delievering a singular fact with some supporting or detailing
# 				descriptions. (Explore the semantics of a terse and effective element elsewhere.) A
# 				topic attribute, limited to 140 characters, is supplied. A content attribute,
# 				limited to 555 characters is supplied. 
#
# QuoteContent -  This is an expanded SimpleContent element, with attributes for Quote, Quotee name,
# 				and Quotee title, as well as the attributes of a SimpleContent. (Quote and content
# 				should work together, and not duplicate meaning. e.g. an army general quoted about
# 				a warzone can be supplemented with facts about the warzone. etc.)
#
# More elements should be created, but not today. ImageContent for photos and possibly
# info-graphics, MapContent, and AudioContent
#
# == Positions
#
# Elements are associated to a position of their own in the pstack. The pstack orders the elements in
# a way according to the flow of the story, and the desire of the author and her choice of
# composition. Position 1 is the topmost position, position n is the last. There is no actual pstack
# object, instead there is just a recording of the every position associated with every story, in 
# one big table. A story's pstack is the extraction of only those positions that are associated with
# that story. Every element attached to those positions are combined and considered the pstack. The 
# Position model is set to 
#	
# @note validates_uniqueness_of :position, scope: :story_id
#
# so there should be no duplicate positions for a story.
#
# Positions have an active attribute, boolean. Set to true to allow the public to view that position,
# and set to false to keep it hidden.
#
# ** (not yet implemented) Each position can have multiple associations to other stories. It is
# intended to associate the content of the element to another related story. It's an imperfect
# implementation since if the element attached to a position was replaced, it could possibly not make
# contextual sense. Be aware of context.
#
# The difference between 'similar stories' and 'related stories' is necessary. In this context, 
# similar stories are considered close in subject but not expansive. e.g. 'Satellite rocketed into 
# Space' is similar to 'International Effort to Save Astronauts Underway' both are similar in the 
# subject: Science/Space. Whereas, 'International Effort to Save Astronauts Underway' and 'Debris 
# Cripples International Space Station' are related stories. Typically, positions will carry related 
# story references since they go to expand on the overarching themes. Stories can be directly 
# connected to other similar stories.
#
# == Citations
#
# Simple citations, only to web references, requiring a title of the webpage, and a url. All elements
# should have at least one citation, but this should be discussed in some sort of authoring
# guidelines documentations.
#
# @!attribute subject
#    Shorty describes this story. Used for the authors of stories to gist the idea.
# @!attribute active_headline_id
#    References the headline used atop the story.   
# @!attribute active_leadline_id
#    References the leadline used atop the story.
# @!attribute section_id
#    Categorized under this section.

class Story < ActiveRecord::Base
    include ActionView::Helpers
    
    belongs_to :section

    has_many :headlines
    has_many :leadlines

    has_many :positions
    has_many :simple_contents, through: :positions, source: :element, source_type: 'SimpleContent'
    has_many :quote_contents, through: :positions, source: :element, source_type: 'QuoteContent'
    
    has_many :simple_content_citations, :through => :simple_contents, :source => :citations 
    has_many :quote_content_citations, :through => :quote_contents, :source => :citations

    has_many :relations
    
    acts_as_taggable_on :themes
    
    validates :subject, :section_id, presence: true
    validates :subject, length: { maximum: 140 }
    
    #@!group Age and Freshness methods
    
    # @!method get_date_created
    # @return [TimeWithZone] the timedate when the citation was created
    # @example 
    #     kat.get_date_created => Mon, 09 Feb 2015 15:18:20 UTC +00:00
    def get_date_created
        self.created_at
    end

    # @!method get_date_updated
    # @return [TimeWithZone] the timedate when the citation was created
    # @example
    #    kat.get_date_updated => Mon, 09 Feb 2015 15:31:29 UTC +00:00
    def get_date_updated
        self.updated_at
    end

    # @!method age
    # The age in words. Time from creation until now.
    # @return [String]
    # @example
    #     cit.age => "about 16 hours"
    def age
        time_ago_in_words(self.get_date_created)
    end

    # @!method freshness
    # The freshness in words. Time from last updated until now.
    # @return [String]
    # @example
    #     hl.freshness => "6 minutes"
    def freshness
        time_ago_in_words(self.get_date_updated)
    end
    
    #@!endgroup
    
    #@!group Getters and Setters of descriptive attributes
    
    # @!method get_subject
    # Returns the subject of the story. A short description of the story, helping authors.
    # @return [String]
    def get_subject
        self.subject
    end
    
    # @!method about
    # Alias for get_subject
    # @return [String]
    alias_method :about, :get_subject
    
    # @!method set_subject(new_subject)
    # Sets the subject to a new subject and then saves.
    # @param [String] new_subject
    # @return [Boolean] if the save was successful
    def set_subject (new_subject)
        self.subject = new_subject
        self.save!
    end

    # @!method filed_under?
    # What Section is this Story filed under?
    # @return [String] the section title of the owning Section
    def filed_under?
        self.section.title
    end
    
    # @!method set_section(section_id)
    # Sets the section_id of this story
    # @param [Integer] section_id
    # @return [Boolean] if the save was successful
    def set_section(section_id)
        self.section_id = section_id
        self.save!
    end    
    #@!endgroup
    
    #@!group headline methods
    
    # @!method get_active_headline
    # The active headline of the story.
    # @return [String]
    def get_active_headline
        self.headlines.find(self.active_headline_id).content
    end
    
    # @!method get_active_headline_id
    # The active headline id of the story.
    # @return [Integer] the id of the active headline
    def get_active_headline_id
        self.active_headline_id
    end

    # @!method active_headline_age
    # The age of the active headline. Time from creation until now.
    # @return [String] the age in words
    def active_headline_age
        self.headlines.find(self.active_headline_id).age
    end

    # @!method active_headline_freshness
    # The freshness of the active headline. From last updated until now.
    # @return [String] the freshness in words 
    def active_headline_freshness
        self.headlines.find(self.active_headline_id).freshness
    end

    # @!method set_active_headline(id)
    # Set the active to a headline that already exists using its id. And saves it to the database.
    # @return [Boolean] if the save was successful
    def set_active_headline(id)
        self.active_headline_id = id   
        self.save!
    end

    # @!method new_headline(new_headline, make_active=true)
    # Create a new headline for this story. make_active true/false, true makes
    #   this new headline the active one.
    # @return [Boolean] if save is successful
    def new_headline(new_headline, make_active=true)
        kat = self.headlines.create(content: new_headline)
        make_active ? self.set_active_headline(kat.id) : false
        self.save!
    end

    # @!method headlines_oldest_to_youngest
    # Return all headlines in order from the oldest to the youngest
    # @return [ActiveCollection]
    def headlines_oldest_to_youngest
        self.headlines.order(created_at: :asc)
    end

    # @!method headlines_youngest_to_oldest
    # Return all headlines from the youngest to oldest
    # @return [ActiveCollection]
    def headlines_youngest_to_oldest
        self.headlines.order(created_at: :desc)        
    end

    # @!method oldest_headline
    # Returns the first created headline.
    # @return [String] the oldest headline
    def oldest_headline
        self.headlines.order(created_at: :asc).first.get_headline
    end

    # @!method youngest_headline
    # Returns the last created headline.
    # @return [String] the youngest headline
    def youngest_headline
        self.headlines.order(created_at: :desc).first.get_headline
    end

    # @!method freshest_headline
    # Returns the most recently updated headline.
    # @return [String] the freshest headline
    def freshest_headline
        self.headlines.order(updated_at: :desc).first.get_headline
    end

    # @!method stalest_headline
    # Returns the oldest updated headline.
    # @return [String] the stalest headline
    def stalest_headline
        self.headlines.order(updated_at: :asc).first.get_headline
    end

    # @!method headlines_by_freshness
    # Returns all headlines from the freshest to the stalest
    # @return [ActiveCollection]
    def headlines_by_freshness
        self.headlines.order(created_at: :desc)    
    end

    # @!method headlines_by_staleness
    # Returns all headlines from the stalest to the freshest
    # @return [ActiveCollection]
    def headlines_by_staleness
        self.headlines.order(updated_at: :asc)
    end    
    #@!endgroup
    
    #@!group leadline methods
    
    # @!method get_active_leadline
    # The active leadline of the story.
    # @return [String]
    def get_active_leadline
        self.leadlines.find(self.active_leadline_id).content
    end
    
    # @!method get_active_leadline_id
    # The active leadline id of the story.
    # @return [Integer] the id of the active leadline
    def get_active_leadline_id
        self.active_leadline_id
    end

    # @!method active_leadline_age
    # The age of the active leadline. Time from creation until now.
    # @return [String] the age in words
    def active_leadline_age
        self.leadlines.find(self.active_leadline_id).age
    end

    # @!method active_leadline_freshness
    # The freshness of the active leadline. From last updated until now.
    # @return [String] the freshness in words 
    def active_leadline_freshness
        self.leadlines.find(self.active_leadline_id).freshness
    end

    # @!method set_active_leadline(id)
    # Set the active to a leadline that already exists using its id. And saves it to the database.
    # @param [Integer] id
    # @return [Boolean] if the save was successful
    def set_active_leadline(id)
        self.active_leadline_id = id   
        self.save!
    end

    # @!method new_leadline(new_leadline, make_active=true)
    # Create a new leadline for this story. make_active true/false, true makes
    #   this new leadline the active one.
    # @return [Boolean] if save is successful
    def new_leadline(new_leadline, make_active=true)
        kat = self.leadlines.create(content: new_leadline)
        make_active ? self.set_active_leadline(kat.id) : false
        self.save!
    end

    # @!method leadlines_oldest_to_youngest
    # Return all leadlines in order from the oldest to the youngest
    # @return [ActiveCollection]
    def leadlines_oldest_to_youngest
        self.leadlines.order(created_at: :asc)
    end

    # @!method leadlines_youngest_to_oldest
    # Return all leadlines from the youngest to oldest
    # @return [ActiveCollection]
    def leadlines_youngest_to_oldest
        self.leadlines.order(created_at: :desc)        
    end

    # @!method oldest_leadline
    # Returns the first created leadline.
    # @return [String] the oldest leadline
    def oldest_leadline
        self.leadlines.order(created_at: :asc).first.get_leadline
    end

    # @!method youngest_leadline
    # Returns the last created leadline.
    # @return [String] the youngest leadline
    def youngest_leadline
        self.leadlines.order(created_at: :desc).first.get_leadline
    end

    # @!method freshest_leadline
    # Returns the most recently updated leadline.
    # @return [String] the freshest leadline
    def freshest_leadline
        self.leadlines.order(updated_at: :desc).first.get_leadline
    end

    # @!method stalest_leadline
    # Returns the oldest updated leadline.
    # @return [String] the stalest leadline
    def stalest_leadline
        self.leadlines.order(updated_at: :asc).first.get_leadline
    end

    # @!method leadlines_by_freshness
    # Returns all leadlines from the freshest to the stalest
    # @return [ActiveCollection]
    def leadlines_by_freshness
        self.leadlines.order(created_at: :desc)    
    end

    # @!method leadlines_by_staleness
    # Returns all leadlines from the stalest to the freshest
    # @return [ActiveCollection]
    def leadlines_by_staleness
        self.leadlines.order(updated_at: :asc)
    end    
    #@!endgroup
    
    #@!group Position Stack (pstack) manipulation        
    
    # @!method get_pstack_forwards
    # The whole pstack in ascending order.
    # @return [ActiveCollection]
    def get_pstack_forwards
        self.positions.order(position: :asc)
    end
    
    # @!method get_pstack_backwards
    # The whole pstack in descending order. 
    # @return [ActiveCollection]
    def get_pstack_backwards
        self.positions.order(position: :desc)
    end

    # @!method get_active_pstack_forwards
    # The pstack with only active positions, in ascending order.
    # @return [ActiveCollection]
    def get_active_pstack_forwards
        self.positions.order(position: :asc).where(active: true)
    end

    # @!method get_active_pstack_backwards
    # The pstack with only active positions, in descending order.
    # @return [ActiveCollection]
    def get_active_pstack_backwards
        self.positions.order(position: :desc).where(active: true)
    end

    # @!method get_inactive_pstack_forwards
    # The pstack with only inactive positions, in ascending order.
    # @return [ActiveCollection]
    def get_inactive_pstack_forwards
        self.positions.order(position: :asc).where(active: false)
    end

    # @!method get_inactive_pstack_backwards
    # The pstack with only inactive positions, in descending order.
    # @return [ActiveCollection]
    def get_inactive_pstack_backwards
        self.positions.order(position: :desc).where(active: false)
    end

    # @!method is_pstack_consistent?
    # Determines if the pstack is in compact order.
    # @example
    #    consistent: [1, 2, 3, 4, 5]
    #    consistent: [15, 16, 17, 18, 19]
    #    inconsistent: [3, 6, 9, 12, 34]
    #    inconsistent: [3, 3, 3, 4, 5] (this shouldn't occur if validation is on)
    # @return [Boolean] answer to your question.        
    def is_pstack_consistent?
        first = self.positions.order(position: :asc).first.position
        last = self.positions.order(position: :asc).last.position
        len = self.positions.length
        
        (last - first) == (len - 1) ? true : false
    end

    # @!method make_pstack_consistent(start=1)
    # Makes the pstack consistent. This is really a helper utility, may never needs to be used,
    # and especially not outside the context of this object.
    # @param [Integer] start what number will the first position start at? default = 1
    # @return [Boolean] returns true on complete
    #    returns false if the param was 0 or 1
    # @example
    #    story.get_pstack_forwards #=> [1, 2, 5, 9, 23]
    #    story.is_consistent? #=> false
    #    story.make_pstack_consistent #=> true
    #    story.get_pstack_forwards #=> [1, 2, 3, 4, 5]
    def make_pstack_consistent(start=1)
        if !(start.is_a? Integer) or (start <= 0)
            return false
        end
        
        first = self.positions.first.position
        
        if self.is_pstack_consistent?
            # True it's in order, then do we need to shift it?
            if (first == start)
                # nothing to do
                return true
            elsif (first != start)
                # TODO: shift it
                self.shift(start - first)
                return true
            end
        else # not consistent
            self.positions.order(position: :asc).each do |p|
                # b/c each story.positions.position needs to be uniqe, we run into the issue of 
                # Validation failed: Position has already been taken
                # so, we'll set the order in negative numbers and just flip their signs
                p.position = -(start)
                p.save!
                start += 1
            end
                # now to switch back to positive positions
            self.positions.each do |p|
                p.position = (p.position).abs 
                p.save!
            end
            return true
        end
    end

    # @!method shift(modifier)
    # Shift all the positions in the pstack by the modifier. Irregardless of activeness
    # of the positions. modifier=1 would shift the pstack down 1, modifier=-1 would shift it up 1
    # @param [Integer] modifier the number to shift the positions
    # @example
    #    story.get_pstack_forwards #=> [1, 2, 3, 4, 5]
    #    story.shift(10)
    #    story.get_pstack_forwards #=> [11, 12, 13, 14, 15]
    def shift(modifier=1)
        if modifier > 0 
            self.positions.reverse.each do |p|
                p.position = p.position + modifier
                p.save!
            end            
        elsif modifier < 0 
            self.positions.each do |p|
                p.position = p.position + modifier
                p.save!
            end    
        end
            return true
    end
    
    # @!method set_pstack_order(order)
    # Reorders the pstack in the order of an array of position ids. First id in the array becomes
    # the first position, the second id becomes the second, and so on.
    # @return [Nil] if there isn't the same number of elements in the array and pstack
    # @return [Nil] if the pstack position id's do not include exactly the id's in the array
    # @return [True] if successful
    def set_pstack_order(order)
        if self.positions.size != order.size
            return nil
        else 
            #determine if the supplied order ids are actually owned by the story
            pstack = self.positions.pluck(:id)
            order.each do |a|
                if !pstack.include?(a)
                    return false
                end
            end
            # set the pstack to the order
            position_order = 1
            order.each do |b|
                p = Position.find(b)
                p.position = -(position_order)
                p.save!
                position_order += 1
            end
            # now to switch back to positive positions
            self.reload
            self.positions.each do |p|
                p.position = (p.position).abs 
                p.save!
            end
            return true
        end
    end
    
    # @!method pop
    # Removes the last position on the pstack, or returns nil if the pstack is empty.
    # @return [Nil] empty pstack
    # @return [True] if operation was successful
    def pop
        if self.positions.empty?
            return nil
        else
            self.positions.destroy(self.positions.order(position: :asc).last)
            return true
        end
    end

    # @!method chop
    # Removes the first position on the pstack, or returns nil if the pstack is empty.
    # @return [Nil] empty pstack
    # @return [True] if operation was successful
    def chop
        if self.positions.empty?
            return nil
        else
            self.positions.destroy(self.positions.order(position: :asc).first)
            self.make_pstack_consistent
        end
    end

    # @!method push (element)
    # Adds an position with and element to the beginning of the pstack. Shifts and makes consistent
    # the remaining of the pstack.
    # @param [SimpleContent, QuoteContent] element any element
    # @return [Boolean]    
    def push(element)
        if self.positions.empty?
            self.positions.create(element_id: element.id, element_type: element.class.to_s, position: 1, active: true)
            return true
        else
            self.make_pstack_consistent(2)
            self.positions.create(element_id: element.id, element_type: element.class.to_s, position: 1, active: true)
            return true
        end
    end
      
        # @!method append(element)
    # Adds an position with and element to the end of the pstack. Makes consistent the pstack.
    # @param [SimpleContent, QuoteContent] element any element
    # @return [Boolean]             
    def append (element)
        if self.positions.empty?
            self.positions.create(element_id: element.id, element_type: element.class.to_s, position: 1, active: true)
            return true
        else
            last_pos = self.positions.order(position: :asc).last.position
            self.positions.create(element_id: element.id, element_type: element.class.to_s, position: last_pos + 1, active: true)
            self.make_pstack_consistent
            return true
        end
    end

    # @!method inactivate_pstack
    # Inactivates all the positions of this story.
    # @return [True] no matter what, humph.
    def inactivate_pstack
        self.positions.each do |p|
            p.inactivate
        end
        return true
    end

    # @!method activate_pstack
    # Activates all the positions of this story.
    # @return [True] no matter what, humph.
    def activate_pstack
        self.positions.each do |p|
            p.activate
        end
        return true
    end
    #@!endgroup
    
    #@!group Content Aggregation
        
    # @!method get_similar_stories
    # Alias for self.relations
    # @return [ActiveCollection] a collection of all the stories tied to self
    def get_similar_stories
        self.relations
    end
                
    # @!method get_citations
    # Returns and array of all the citations that are attached through positions.
    # @return [Array] all the citations associated through positions
    def get_citations
        self.simple_content_citations + self.quote_content_citations
    end

    # @!method new_similar_story(story_id_to_connect_to)
            # Creates a new tie between the parent story and a passed story id.
    # @param [Integer] story_id_to_connect_to is the story id to link to
    # @return [Boolean] true if save is successful, false if save is unsuccessful, if similar
    #    story is already a similiar story, or if similiar story and self are the same
    def new_similar_story(story_id_to_connect_to)
        # if the param is the same as self, or if param is aready connected to self
        a = self.relations.pluck(:tie_id)
        if self.id != story_id_to_connect_to and !(a.include?(story_id_to_connect_to))
            self.relations.create!(tie_id: story_id_to_connect_to, tie_type: "Story") ? true : false
        else
            return false
        end
    end

    # @!method remove_similar_story(story_id_to_remove)
    # Destroys the connection between self and the similar story
    # @param [Integer] story_id_to_remove the id of the tied story
    # @return [Boolean] true if the destroyed, false if not
    def remove_similar_story(story_id_to_remove)
        a = self.relations.pluck(:tie_id)
        if a.include?(story_id_to_remove)
            self.relations.destroy(Relation.where(story_id: self.id, tie_id: story_id_to_remove, tie_type: "Story")) ? true : false
        else
            return false
        end
    end
    #@!endgroup        
       
public :age, :freshness, :get_date_created, :get_date_updated

public :filed_under?, :get_subject, :about, :set_subject, :set_section

public :get_active_headline, :get_active_headline_id, :active_headline_age, :active_headline_freshness, :set_active_headline, :new_headline, :headlines_oldest_to_youngest, :headlines_youngest_to_oldest, :oldest_headline, :youngest_headline, :freshest_headline, :stalest_headline, :headlines_by_freshness, :headlines_by_staleness

public :get_active_leadline, :get_active_leadline_id, :active_leadline_age, :active_leadline_freshness, :set_active_leadline, :new_leadline, :leadlines_oldest_to_youngest, :leadlines_youngest_to_oldest, :oldest_leadline, :youngest_leadline, :freshest_leadline, :stalest_leadline, :leadlines_by_freshness, :leadlines_by_staleness

public :get_pstack_forwards, :get_pstack_backwards, :get_active_pstack_forwards, :get_active_pstack_backwards, :get_inactive_pstack_forwards, :get_inactive_pstack_backwards, :pop, :chop, :push, :append, :set_pstack_order, :is_pstack_consistent?, :make_pstack_consistent, :shift, :inactivate_pstack, :activate_pstack

public :get_citations

public :new_similar_story, :remove_similar_story, :get_similar_stories
        
end