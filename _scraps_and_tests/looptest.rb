require 'securerandom'

TOTAL_STORIES = 50

1.upto(TOTAL_STORIES) do |s|
    rand_num_connections = SecureRandom.random_number(4) + 1
    1.upto(rand_num_connections) do |connect|
        begin random_story_id = SecureRandom.random_number(TOTAL_STORIES) + 1 end until random_story_id != s
        puts "s = #{s} and random_story_id = #{random_story_id}"
    end
end