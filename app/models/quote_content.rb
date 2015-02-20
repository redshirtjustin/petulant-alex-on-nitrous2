##
# QuoteContent, is the basic content element (SimpleContent) plus a quote attribute.
# Further attributes to contextualize the quote. It should be accessed through the pstack.
#
# The content should work to describe events that the quote illustrates from the perspective
# of the quotee.
#
# Some descriptive attributes have been left alone from methods because you should be
# mostly gaining access to them by working through rails and the built in association methods
# provided.
#
# @!attribute topic
#    @return [String] the topic, shortly describes the element, max length 140
# @!attribute content
#    @return [Text] the content, max length 555
# @!attribute quote
#    @return [Text] quote, max length 555
# @!attribute quotee_name
#    @return [String] quotee name, max length 140
# @!attribute quotee_title
#    @return [String] quotee title, or description, max length 140

class QuoteContent < ActiveRecord::Base
    has_many :positions, as: :element
    has_many :stories, through: :positions
    has_many :citations, as: :cite
    
    acts_as_taggable_on :themes, :contexts
    
    validates :topic, :content, :quote, :quotee_name, :quotee_title, presence: true
    validates :topic, :quotee_name, :quotee_title, length: { maximum: 140 }
    validates :content, :quote, length: { maximum: 555 }
  
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

    # @!method get_quote
    # The quote of the element.
    # @return [String]
    def get_quote
        self.quote
    end

    # @!method get_quotee_name
    # The name of the quoted.
    # @return [String]
    def get_quotee_name
        self.quotee_name
    end

    # @!method get_quotee_title
    # The title of quoted.
    # @return [String]
    def get_quotee_title
        self.quotee_title
    end
    
    # @!method get_content
    # The content of the element.
    # @return [Text]
    def get_content
        self.content
    end
    
    #@!endgroup
    
    #@!group Descriptive Attributes Setters
    
    # @!method set_quote(new_quote)
    # Set and save a new quote.
    # @param [Text] new_quote is limited to 555 characters
    # @return [Boolean] if the save is successful
    def set_quote(new_quote)
        self.quote = new_quote
        self.save
    end
    
    # @!method set_topic(new_topic)
    # Set and save a new_topic.
    # @param [String] new_topic is limited to 140 characters
    # @return [Boolean] if the save is successful
    def set_topic(new_topic)
        self.topic = new_topic
        self.save
    end
    
    # @!method set_quotee_name(name)
    # Set and save the name of the quoted.
    # @param [String] name is limited to 140 characters
    # @return [Boolean] if the save is successful
    def set_quotee_name(name)
        self.quotee_name = name
        self.save
    end

    # @!method set_quotee_title(title)
    # Set and save the title of the quoted.
    # @param [String] title is limited to 140 charcters
    # @return [Boolean] if the save is successful
    def set_quotee_title(title)
        self.quotee_title = title
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

    public :get_topic, :get_quote, :get_quotee_name, :get_quotee_title, :get_content 

    public :set_topic, :set_quote, :set_quotee_name, :set_quotee_title, :set_content
    
end