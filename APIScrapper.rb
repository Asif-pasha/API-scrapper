require "httparty"
require "json"
class Api
	attr_accessor :title,:body,:tagid,:source,:taglist,:approved,:rank,:result
	def initialize(attributes)
		@title =attributes[:title]
		@body = attributes[:body]
		@tagid = attributes[:tagid].to_a
		@source =attributes[:source]
		@taglist = attributes[:taglist]
		@approved = attributes[:approved]
		@rank = attributes[:rank]
		@result = attributes[:result].to_a
	end
	def fetch_local
		response = HTTParty.get("http://localhost:3000/tags.json")
		result=JSON.parse(response.body)
		result.each do |res|
			@tagid.push(res["id"])
			@result.push(res["name"])
		end		
	end
	def update
		option = @taglist -@result	
		option.each do |opt|
			HTTParty.post("http://localhost:3000/tags.json",
      		body: {
    			tag: { 
    				name: opt 
    				}
    			})
		end
    end
    def assign_update
    	HTTParty.post("http://localhost:3000/assignments.json",
      		body: {
    			assignment: { 
    				title: @title,
    				body: @body,
    				source: @source,
    				tag_ids: @tagid,
    				approved: @approved 
    				}
    			})
    end

	def fetch_api
		puts "enter the slug"
		name=gets.chomp
		response=HTTParty.get("https://www.codewars.com/api/v1/code-challenges/#{name}")
		result=JSON.parse(response.body)
		@title = result["name"]
		@body = result["description"]
		@source = result["url"]
		@taglist =  result["tags"]
		@approved = result["approvedAt"]
		@rank = result["rank"]			
	end
	def api_call(i = 'y')
		cnt=i
		while cnt=='y'
		puts "Enter '1'for entering the slug\nEnter '2' to display\nEnter '3' to continue or exit"
		option=gets.to_i
 			case option
 				when 1
 				fetch_api
				when 2 
				api_display
				when 3 
				puts "Do you want to still continue  then press 'y' or anyother key to exit"
 		    	cnt=gets.chomp		
	 			else puts "Invalid option" 					
 			end
 		end
	end
	
	def api_display
		puts "title:#{@title}\nbody:#{@body}\nuserid:#{@userid}\nSource:#{@source}\nTaglist:#{@taglist}---\nApproved:#{@approved}"
	end
end
a= Api.new({ }) 
a.api_call
a.fetch_local
a.update
a.assign_update
