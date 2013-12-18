require 'nokogiri'
require 'open-uri'

# Method to output queried anime to screen
def to_screen(id, title, desc)
	# Formatting output  #
	# ###############

	#ID Title
	id_title = "ID:#{id} >> "
	print "\n#{id_title}"
	# Series Title
	print "[#{title}]\n"
	# Bottom border formatting
	title_len = title.length + id_title.length + 4
	title_len.times { print "=" }
	# Description
	puts "\n#{desc}\n"
end

# Method to store matches to robot anime
def robot_query(id, title, desc, robot_db)
	## >> Make this into a search/genre selection method
	# # Robots check
	if(desc.match(/robot/))
		# Open a file and record the matching entry
		File.open("anime_robots.txt", "a") do
			|file| file.write("\n\n[ID\# #{id}] Title: #{title}\n----------\nDescription:\n----------\n#{desc}\n")
		end
		robot_db.push(desc)
		to_screen(id, title, desc)
	end
end


# Starting values
id = 0
robot_db = []
ani_db = []

### User input section ###
# Get user command for amount of entries to scrape
print "How many entries would you like to scrape?\n>> "
entry_num = gets.chomp
# Get user command for anime ID to begin at
print "Which anime ID would you like to begin at?\n>> "
id = gets.chomp.to_i

# Loading message
print "Loading now, please wait...\n------------\n"

# Web scraper and storage
(entry_num).to_i.times do
	begin
		# URL for scraping
		url = "http://anilist.co/anime/#{id}"
		data = Nokogiri::HTML(open(url))

		# Data sources #
		############
		title = data.at_css("#series_right h1").text.strip
		desc = data.at_css("#series_des").text.strip

		# Call robot matching method
		robot_query(id, title, desc, robot_db)
		# Push total titles and id into ani_db
		ani_db.push("ID\# (#{id}) " + title)

		# Show progress
		print "."
		# Increment ID counter
		id +=1

	# Rescue after hitting URL with no content
	rescue Exception
		id+=1
		retry
	end
end

# Print out report
puts "\nTotal list queried: \n------------"
ani_db.each { |title| puts title}
puts "------------\nNumber of robot anime's found: " + robot_db.length.to_s + " out of " + ani_db.length.to_s
