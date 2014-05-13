Camping.goes :Contacts

module Contacts::Controllers
	class Index < R '/'
		def get
			#Time.now.to_s
			@time = Time.now.to_s
			render :create_new
		end

		def post
			@flash = "New user created"
			render :create_new
		end
	end

	#class Create < R '/create'
#		def post
#			p "New user created"
#			render :create_new
#		end
#	end

end

module Contacts::Views
	def layout
		html do
			head do
				title { "Contact Manager" }
			end
			body { self << yield }
		end
	end

	def create_new
		p "enter a name"
		if @flash 
			p @flash
		end
		form :method=>'post' do
			input type: 'input', name: 'name', value: '' 
			input type: 'submit', name: 'submit', value: 'Add'
		end	
	end
end

module Contacts::Models
	class Contact < Base 
	end
	
	class BasicFields < V 1.0
		def self.up
			create_table Contact.table_name do |t|
				t.string :user_id
				t.string :emails_json
				t.timestamps
			end
		end

		def self.down
			drop_table Contact.table_name
		end
	end
end

def Contacts.create
	Contacts::Models.create_schema
end
