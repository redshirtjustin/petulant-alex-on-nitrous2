##
# A reference to an online source. Associated to any element using the 'cite' hook. 
# 
# @!attribute title
#    @return [String] the title of the online source, limited to 140 chars
# @!attribute url
#    @return [String] the url of the online source, limited to a properly formated url

class Citation < ActiveRecord::Base
    include ActionView::Helpers
    
    belongs_to :cite, polymorphic: true

    validates :title, :url, presence: true
    validates :title, length: { maximum: 140 }
    validates :url, format: { with: /\A(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\z/i }  
    # validates_associated :cite

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

    # @!method get_cite_title 
    # The title of the citation website.
    # @return [String]
    # @example
    #     hl.get_cite_title => "The Daily Planet Website."
    def get_cite_title
        self.title
    end

    # @!method get_cite_url 
    # The url of the citation website.
    # @return [String]
    # @example
    #     hl.get_cite_url => "http://www.thedailyplanet.com/"
    def get_cite_url
        self.url
    end

    # @!method set_cite_title(new_title) 
    # Set a new cite title and save to the database.
    # @param [String] new_title is limited 140 characters, can not be blank.
    # @return [Boolean] if it saves
    def set_cite_title(new_title)
        self.title = new_title
        self.save
    end
    
    # @!method set_cite_url(new_url) 
    # Set a new cite url and save to the database.
    # @param [String] new_url can not be blank, must follow the regex: /\A(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\z/
    #    url: http://www.website.com/and-some-trailing-stuff
    # @return [Boolean] if it saves
    def set_cite_url(new_url)
        self.title = new_url
        self.save
    end
    
    #@!endgroup

    public :get_date_created, :get_date_updated, :age, :freshness
    
    public :get_cite_title, :get_cite_url 

    public :set_cite_title, :set_cite_url
end

