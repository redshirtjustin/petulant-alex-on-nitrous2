##
# Section describes a heirarchical categorization. All Stories are intended to be filed under
# a singular section. 
#
# @!attribute title
#    @return [String] the main name of the section, limited to 75 chars
# @!attribute description
#    @return [Text] description of the section, limited to 140 chars

class Section < ActiveRecord::Base
    has_many :stories
    
    validates :title, :description, presence: true
    validates :title, length: { maximum: 75 }
    validates :description, length: { maximum: 140 }

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
    
    #@!group Descriptive Attributes getters and setters

    # @!method get_title
    # The title of the Section. 
    # @return [String]
    def get_title
        self.title
    end
    
    # @!method get_description
    # The description of the Section.
    # @return [String]
    def get_description
        self.description
    end

    # @!method set_title(new_title)
    # Set a new title of the Section, and save to the database.
    # @param [String] new_title is limited to 75 characters, can not be blank
    # @return [Boolean] if the save was successful
    def set_title(new_title)
        self.title = new_title
        self.save
    end    

    # @!method set_description(new_description)
    # Set a new description of the Section, and save to the database.
    # @param [String] new_description is limited to 140 characters, can not be blank
    # @return [Boolean] if the save was successful
    def set_description(new_description)
        self.description = new_description
        self.save
    end
    
    #@!endgroup

    public :get_date_created, :get_date_updated, :age, :freshness

    public :get_title, :get_description

    public  :set_title, :set_description
    
end