##
# SimpleContent, is the basic content element, a segment of a Story. It should be accessed through
# the pstack. 
#
# Some descriptive attributes have been left alone from methods because you should be
# mostly gaining access to them by working through rails and the built in association methods
# provided.
#
# @!attribute topic
#    @return [String] the topic, shortly describes the element, max length 140
# @!attribute content
#    @return [Text] the content, max length 555

class SimpleContent < ActiveRecord::Base
    has_many :positions, as: :element
    has_many :stories, through: :positions
    has_many :citations, as: :cite
    
    acts_as_taggable_on :themes, :contexts
    
    validates :topic, :content, presence: true
    validates :topic, length: { maximum: 140 }
    validates :content, length: { maximum: 555 }
    
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
    
    #@!group Descriptive Attributes Getters
    
    # @!method get_topic 
    # The topic of element.Shortly describes the element.
    # @return [String] 
    def get_topic
        self.topic
    end
    
    # @!method get_content
    # The content of the element.
    # @return [Text]
    def get_content
        self.content
    end
    
    #@!endgroup
    
    #@!group Descriptive Attributes Setters
    
    # @!method set_topic(new_topic)
    # Set and save a new_topic.
    # @param [String] new_topic is limited to 140 characters
    # @return [Boolean] if the save is successful
    def set_topic(new_topic)
        self.topic = new_topic
        self.save
    end

    # @!method set_content(new_content)
    # Set and save the content of the element.
    # @param [Text] new_content is limited to 555 characters
    # @return [Boolean] if the save is successful
    def set_content(new_content)
        self.content = new_content
        self.save
    end
    
    public :get_date_created, :get_date_updated, :age, :freshness
    
    public :get_content, :get_topic
    
    public :set_topic, :set_content
    
end
