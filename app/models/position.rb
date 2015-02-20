##
# A position. A collection of positions, associated to a single owning Story is considered the
# 'positions stack' or 'pstack'.
#
# @!attribute position
#    @return [Integer] the position in the pstack of an associated story
# @!attribute active
#    @return [Boolean] the active state in teh pstack, inactive denotes that public users will not
#    be able to view this position's content

class Position < ActiveRecord::Base
    belongs_to :story
    belongs_to :element, polymorphic: true
    belongs_to :simple_content, class_name: "SimpleContent", foreign_key: "position_id"
    belongs_to :quote_content, class_name: "QuoteContent", foreign_key: "position_id"
    has_many :relations, as: :tie

    validates :story_id, :element_id, :element_type, :position, presence: true
    validates :active, inclusion: { in: [true, false] }
    validates_uniqueness_of :position, scope: :story_id
    
# @!group Age and Freshness getters
    
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
    
    #@!group Activation Methods
    
    # @!method activate
    # Sets the position to active, 'activates the position' and saves it
    # @return [Boolean] if the save is successful
    def activate
        self.active = true
        self.save
    end

    # @!method inactivate
    # Sets the position to inactive, 'inactivates the position' and saves it
    # @return [Boolean] if the save is successful
    def inactivate
        self.active = false
        self.save
    end

    # @!method is_active?
    # @return [Boolean] is the position active?
    def is_active?
        self.active
    end

    # @!method is_inactive?
    # @return [Boolean] is the position inactive?
    def is_inactive?
        !self.active       
    end
    
    #@!endgroup
    
    #@!group Descriptive Attributes getters and setters
    
    # @!method get_position
    # The order in the pstack of this position.
    # @return [Integer] the position in the pstack, 1 is topmost
    def get_position
        self.position
    end
    
    # @!method get_owner
    # The Story owner's id.
    # @return [Integer] the owning Story id
    def get_owner
        self.story_id
    end
    
    # @!method get_element_id
    # The id of the element attached to this position.
    # @return [Integer]
    def get_element_id
        self.element_id
    end

    # @!method get_element_type
    # The type of the element attached to this position.
    # @return [String]
    #    The class name of the element.
    def get_element_type
        self.element_type
    end
    
    # @!method set_position(new_position)
    # Set and save a new position order. This should be internally used.
    # @param [Integer] new_position
    # @return [Boolean] if the save was successful
    def set_position(new_position)
        self.position = new_position
        self.save
    end
    
    # @!method set_owner(new_id)
    # Set and save a new owner.
    # @param [Integer] new_id
    # @return [Boolean] if the save was successful
    def set_owner(new_id)
        self.story_id = new_id
        self.save
    end

    # @!method set_element(element)
    # Sets the element references to the passed element.
    # @param [QuoteContent, SimpleContent] element pass in the actual element that this position
    #    will reference
    # @return [Boolean] if the save was successful
    def set_element(element)
        self.element_id = element.id
        self.element_type = element.class.to_s
        self.save
    end
        
    #@!endgroup
        
    #@!group Utilities
    
    # @!method bump_up 
    # Decrements the self.position of this Position. 1 is considered the topmost. Should be thought
    # as if the position is moving up the pstack. This is really a utility method for other
    # methods. Don't go using willy nilly.
    # @return [Boolean] if the save is successful
    # @example
    #    self.position = 7
    #    self.bump_up
    #    self.get_position #=> 6
    def bump_up
        self.position -= 1
        self.save
    end
    
    # @!method bump_down
    # Increments the self.position of this Position. 1 is considered the topmost. Should be thought
    # as if the position is moving down the pstack. This is really a utility method for other
    # methods. Don't go using willy nilly.
    # @return [Boolean] if the save is successful
    # @example
    #    self.position = 7
    #    self.bump_down
    #    self.get_position #=> 8 
    def bump_down
        self.position += 1
        self.save
    end
        
        
        # @!method new_related_story(story_id)
        # Creates a new tie between this position and a related stroy
        # @param [Integer] story_id the id of the related story
        def new_related_story(story_id)
            
        end
        
    #@!endgroup

    public :get_date_created, :get_date_updated, :age, :freshness

    public :activate, :inactivate, :is_active?, :is_inactive? 

    public :get_owner, :get_element_id, :get_element_type, :get_position   

    public :set_owner, :set_position, :set_element

    public :bump_up, :bump_down
      
    public :new_related_story
end