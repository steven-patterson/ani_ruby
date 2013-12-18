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

# Method to store matches
def search_query(id, title, desc, search_db, search_term)
	# If anything in description matches term, record to file
	if(desc.match(/#{search_term}/))
		# Open a file and record the matching entry
		File.open("anime_matches.txt", "a") do
			|file| file.write("\n\n[ID\# #{id}] Title: #{title}\n----------\nDescription:\n----------\n#{desc}\n")
		end
		# Store the description in search_db
		search_db.push(desc)
		# Output found results to screen
		to_screen(id, title, desc)
	end
end


# Starting values
id = 0
search_db = []
ani_db = []

### Welcome Message ###
puts "\n===== Welcome to Ani_Ruby ====="
puts "Please begin your search for a desired type of anime!"

### User input section ###
# Get user command for amount of entries to scrape
print "\nHow many entries would you like to scrape?\n>> "
entry_num = gets.chomp
# Get user command for anime ID to begin at
print "Which anime ID would you like to begin at?\n>> "
id = gets.chomp.to_i
# Get user search term
print "What term do you want to search for?\n>> "
search_term = gets.chomp.to_s

# Loading message
print "\nLoading now, please wait...\n------------\n"

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

		# Call anime matching method
		search_query(id, title, desc, search_db, search_term)
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
puts "------------\nNumber of \"#{search_term}\" anime's found:#{search_db.length.to_s} out of #{ani_db.length.to_s}"
