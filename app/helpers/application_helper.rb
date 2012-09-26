module ApplicationHelper
	#truncate text by words
	def truncate_words(thought, wordcount) 
		thought.split[0..(wordcount-1)].join(" ") +(thought.split.size > wordcount ? "..." : "") 
	end
end