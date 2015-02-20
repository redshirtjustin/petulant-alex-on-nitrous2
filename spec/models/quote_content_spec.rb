require 'rails_helper.rb'

RSpec.describe QuoteContent do
    context "/ validations /" do
        before :each do
            @quote = QuoteContent.new(topic: "Topics quickly describe the content.", 
                content: Faker::Lorem.characters(555), quote: Faker::Lorem.characters(555),
                quotee_name: Faker::Lorem.characters(140), quotee_title: Faker::Lorem.characters(140))
        end
        
        it "is valid if there is a topic, content, quote, quotee name, and quotee title" do
            expect(@quote).to be_valid
        end
        
        it "is invalid if topic is more than 140 characters" do 
            @quote.topic = Faker::Lorem.characters(141)
            @quote.valid?
            expect(@quote.errors[:topic]).to include "is too long (maximum is 140 characters)"
        end
        
        it "is invalid if content is more than 555 characters" do 
            @quote.content = Faker::Lorem.characters(556)
            @quote.valid?
            expect(@quote.errors[:content]).to include "is too long (maximum is 555 characters)"
        end
        
        it "is invalid if quote is more than 555 characters" do 
            @quote.quote = Faker::Lorem.characters(556)
            @quote.valid?
            expect(@quote.errors[:quote]).to include "is too long (maximum is 555 characters)"        
        end
        
        it "is invalid if quotee name is more than 140 characters" do 
            @quote.quotee_name = Faker::Lorem.characters(141)
            @quote.valid?
            expect(@quote.errors[:quotee_name]).to include "is too long (maximum is 140 characters)"
        end
        
        it "is invalid if quotee title is more than 140 characters" do 
            @quote.quotee_title = Faker::Lorem.characters(141)
            @quote.valid?
            expect(@quote.errors[:quotee_title]).to include "is too long (maximum is 140 characters)"
        end
    end
    
    context "/ data retrieval using instance methods /" do
        before :each do
            @quote = QuoteContent.create(topic: "Topics quickly describe the content.", 
                content: Faker::Lorem.characters(555), quote: Faker::Lorem.characters(555),
                quotee_name: Faker::Lorem.characters(140), quotee_title: Faker::Lorem.characters(140))
        end
        
        it "returns the topic" do 
            expect(@quote.get_topic).to eq @quote.topic
        end
        it "returns the content" do 
            expect(@quote.get_content).to eq @quote.content
        end
        it "returns the quote" do 
            expect(@quote.get_quote).to eq @quote.quote
        end
        it "returns the quotee name" do 
            expect(@quote.quotee_name).to eq @quote.quotee_name
        end
        it "returns the quotee title" do 
            expect(@quote.quotee_title).to eq @quote.quotee_title
        end
    end
    
    context "/ data setting using instances methods /" do
        before :each do
            @quote = QuoteContent.create(topic: "Topics quickly describe the content.", 
                content: Faker::Lorem.characters(555), quote: Faker::Lorem.characters(555),
                quotee_name: Faker::Lorem.characters(140), quotee_title: Faker::Lorem.characters(140))
        end
        
        it "sets the topic and saves it to the database" do
            topic = "A new topic"
            @quote.set_topic(topic)
            @quote.reload
            expect(@quote.topic).to eq topic
        end
        
        it "sets the content and saves it to the database" do 
            content = "Some new content"
            @quote.set_content(content)
            @quote.reload
            expect(@quote.content).to eq content
        end
        
        it "sets the quote and saves it to the database" do 
            quote = "Some new quote"
            @quote.set_quote(quote)
            @quote.reload
            expect(@quote.quote).to eq quote
        end
        
        it "sets the quotee name and saves it to the database" do 
            quotee_name = "Some new quotee name"
            @quote.set_quotee_name(quotee_name)
            @quote.reload
            expect(@quote.quotee_name).to eq quotee_name
        end
        
        it "sets the quotee title and saves it to the database" do 
            quotee_title = "Some new quotee title"
            @quote.set_quotee_title(quotee_title)
            @quote.reload
            expect(@quote.quotee_title).to eq quotee_title
        end
    end
end

