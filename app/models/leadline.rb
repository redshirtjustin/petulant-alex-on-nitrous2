##
# A single leadline. Leadlines should really be accessed through the owning Story object.
# It is intended that a Story object has several leadlines, and one active leadline that can 
# be accessed through the Story.
#
# @!attribute content
#    @return [String] the leadline, limited to 555 chars

class Leadline < ActiveRecord::Base    
    include ActionView::Helpers
    belongs_to :story
    
    validates :content, presence: true, length: { maximum: 555 }

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
    
    #@!group Descriptive attributes getters and setters
    
    # @!method get_id
    # The id of the leadline.
    # @return [Integer]
    # @example
    #     hl.get_id => 1
    def get_id
        return self.id
    end
    
    # @!method get_leadline
    # The content of the leadline.
    # @return [String]
    # @example
    #     hl.get_leadline => "Breaking news! People need to read this!"
    def get_leadline
        return self.content
    end
    
    # @!method get_owner
    # The owning Story id.
    # @return [Integer]
    # @example
    #     hl.get_owner => 1
    def get_owner
        return self.story_id
    end
    
    # @!method set_leadline(new_leadline="")
    # Sets this leadline content to new_leadline, and saves the leadline to the database.
    # @param [String] new_leadline is limited to 140 characters
    # @return [Boolean] if save is successful
    # @example
    #     hl.set_leadline("Breaking news! People need to read this!") => true
    def set_leadline (new_leadline="") 
        self.content = new_leadline
        self.save
    end

    # @!method set_owner(id)
    # Sets the leadline owner to the param, and saves it to the database.
    # @param [Integer] id
    # @return [Boolean] if save is successful
    # @example
    #     hl.set_owner(1)) => true
    def set_owner (id)
        self.story_id = id
        self.save
    end
    
    #@!endgroup

    public :get_date_created, :get_date_updated, :age, :freshness

    public :get_leadline, :get_id, :get_owner
    
    public :set_leadline, :set_owner
    
end