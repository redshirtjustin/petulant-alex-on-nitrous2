# This is mostly lorem seeding, intended only for testing purposes. Seeding is created in the
# following order.
#
# 1) Clear up the databse just in case.
# 2) CONSTANTS
# 3) SECTION seeding
# 4) STORY seeding
# 5) SIMPLECONTENT seeding
# 6) QUOTECONTENT seeding
# 7) POSITIONS seeding
#    7a) RELATED STORIES seeding
# 8) HEADLINES and LEADLINES seeding
# 9) CITATIONS seeding SIMPLECONTENT
# 10) CITATIONS seeding QUOTECONTENT
# 11) SIMILAR STORIES seeding


# Clear up the databse just in case.
Citation.delete_all
Headline.delete_all
Leadline.delete_all
Position.delete_all
QuoteContent.delete_all
Section.delete_all
SimpleContent.delete_all
Story.delete_all


# CONSTANTS
TOTAL_STORIES = 50
TOTAL_SIMPLE_ELEMENTS = 250
TOTAL_QUOTE_ELEMENTS = 100


# SECTION seeding
sec1 = Section.create!(title: 'Business & Economics', description: 'News about business and economics.')
sec2 = Section.create!(title: 'Government & Politics', description: 'News about government and politics.')
sec3 = Section.create!(title: 'Sports', description: 'News about sports.')
sec4 = Section.create!(title: 'Science', description: 'News about science.')
sec5 = Section.create!(title: 'Environment', description: 'News about the environment.')
sec6 = Section.create!(title: 'Arts & Entertainment', description: 'News about arts and entertainment.')


# STORY seeding
1.upto(TOTAL_STORIES) do |s|
       # get a random section to create this story under
      rand_sec_num = SecureRandom.random_number(6) + 1

      # Create story, with lorem subject, and random section
      story = Story.create!(subject: Faker::Lorem.sentence, section_id: rand_sec_num)
end


# SIMPLECONTENT seeding
1.upto(TOTAL_SIMPLE_ELEMENTS) do |a|
      # Create simple element, with lorem topic and lorem content
      simple = SimpleContent.create!(topic: Faker::Lorem.sentence, content: Faker::Lorem.paragraph)
end


# QUOTECONTENT seeding
1.upto(TOTAL_QUOTE_ELEMENTS) do |q|
      # Create quote element, with lorem topic, lorem content, lorem quote, fictitious name and title
      quote = QuoteContent.create!(topic: Faker::Lorem.sentence, content: Faker::Lorem.paragraph, quote: Faker::Lorem.paragraph, quotee_name: Faker::Name.name, quotee_title: Faker::Name.title)
end


# POSITIONS seeding
1.upto(TOTAL_STORIES) do |s|
    # Pick a number of elements that a story will have
    rand_num_eles = SecureRandom.random_number(12) + 1

    # Arrays for tracking which elements we've used, so we don't duplicate
    track_si = []
    track_qt = []

    # let's start making associates between elements and this story.
    1.upto(rand_num_eles) do |c|
    # Random which element type we choose
    # on 0, 1 a simple element will be associated
    # on 2 a quote element will be associated
    if (SecureRandom.random_number(3) < 2)
        rand_simple_id = SecureRandom.random_number(TOTAL_SIMPLE_ELEMENTS) + 1 # 0 won't be an id so +1

        # keep up random number generation until one is found that hasn't been taken before
        until !(track_si.include?(rand_simple_id))
              rand_simple_id = SecureRandom.random_number(TOTAL_SIMPLE_ELEMENTS) + 1
        end
        track_si << rand_simple_id # add it to the list of already associated elements

        # Create the position
        sele = Position.create!(story_id: s, element_id: rand_simple_id, element_type: "SimpleContent", active: true, position: c)
        sele.reload

        # Make some connections between positions and related stories
        if (SecureRandom.random_number(10) < 2) # about a 10% chance that this position has a connection
            rand_story_id = SecureRandom.random_number(TOTAL_STORIES) + 1
            relel = Relation.create!(story_id: rand_story_id, tie_id: sele.id, tie_type: sele.class.to_s)
        end
    else
        # Same as creating a SimpleContent position
        rand_quote_id = SecureRandom.random_number(TOTAL_QUOTE_ELEMENTS) + 1

        until !(track_qt.include?(rand_quote_id))
        rand_quote_id = SecureRandom.random_number(TOTAL_QUOTE_ELEMENTS) + 1
        end
        track_qt << rand_quote_id

        qele = Position.create!(story_id: s, element_id: rand_quote_id, element_type: "QuoteContent", active: true, position: c)

        # Make some connections between positions and related stories
        if (SecureRandom.random_number(10) < 2) # about a 10% chance that this position has a connection
            rand_story_id = SecureRandom.random_number(TOTAL_STORIES) + 1
            relel = Relation.create!(story_id: rand_story_id, tie_id: qele.id, tie_type: qele.class.to_s)
        end
    end
    end
end

# HEADLINES and LEADLINES seeding
1.upto(TOTAL_STORIES) do |s|
    # find a random total of associated headlines and leadlines
    rand_num_headlines = SecureRandom.random_number(3) + 1
    rand_num_leadlines = SecureRandom.random_number(2) + 1
   
    headline = 0 # defined in this scope
    leadline = 0

    1.upto(rand_num_headlines) do |hl|
        # Create a headline
        headline = Headline.create!(content: Faker::Lorem.sentence, story_id: s)
    end

    # Leadline seeding
    1.upto(rand_num_leadlines) do |ll|
        # Create a leadline
        leadline = Leadline.create!(content: Faker::Lorem.sentence, story_id: s)
    end

    # set active headline and leadline
    story = Story.find(s)
    story.set_active_headline(headline.id)
    story.set_active_leadline(leadline.id)
end

# CITATIONS seeding SIMPLECONTENT
1.upto(TOTAL_SIMPLE_ELEMENTS) do |s|
  # get random number of citations for this element
  rand_num_citations = SecureRandom.random_number(3) + 1

  1.upto(rand_num_citations) do |cit|
    citation = Citation.create!(cite_id: s, cite_type: "SimpleContent", title: Faker::Lorem::sentence, url: Faker::Internet::url)
  end
end

# CITATIONS seeding QUOTECONTENT
1.upto(TOTAL_QUOTE_ELEMENTS) do |s|
    # get random number of citations for this element
    rand_num_citations = SecureRandom.random_number(3) + 1

    1.upto(rand_num_citations) do |cit|
        citation = Citation.create!(cite_id: s, cite_type: "QuoteContent", title: Faker::Lorem::sentence, url: Faker::Internet::url)
    end
end

# SIMILAR STORIES seeding
1.upto(TOTAL_STORIES) do |s|
    rand_num_connections = SecureRandom.random_number(4) + 1
    1.upto(rand_num_connections) do |connect|
        begin random_story_id = SecureRandom.random_number(TOTAL_STORIES) + 1 end until random_story_id != s
        similar = Relation.create!(story_id: s, tie_id: random_story_id, tie_type: "Story")
    end
end

