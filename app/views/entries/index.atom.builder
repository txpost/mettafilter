atom_feed do |feed|
	feed.title("iamIntrovert.org RSS")
	feed.updated(@entries.first.created_at)

	@entries.each do |anEntry|
		feed.entry(anEntry) do |post|
			post.title(anEntry.title)
			post.content(anEntry.body, :type => 'html')
			post.author { |author| author.name("Jack's Inner Wisdom") }
		end
	end
end
