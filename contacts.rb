require 'camping'
require 'byebug'
Camping.goes :Contacts


module Contacts::Controllers
	class Index < R '/'
		def get
			#Time.now.to_s
			@time = Time.now.to_s
			@contacts = Contact.all
			       
			render :create_new
		end

		def post
			@flash = "New user created"
			contact_list = Contacts::Models::Contact.new
    			#contact_list.user_id ='0' 
			contact_list.email = 'email@mailinator.com'
			contact_list.save
			@contacts = Contact.all
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
		@contacts.each do |contact|
			p contact.id
			p contact.email
		end
		form :method=>'post' do
			input type: 'input', name: 'name', value: '' 
			input type: 'submit', name: 'submit', value: 'Add'
		end	
	end
end

module Contacts::Models
	
	class User < Base
	end
	class Contact < Base 
		belongs_to :contact_list
	end

	class ContactList < Base
		belongs_to :user
		has_many :contacts 
	end
	
	class BasicFields < V 1.0
		def self.up
			create_table Contact.table_name, :force => true do |t|
				t.string :email
				t.integer :contact_list_id
				t.timestamps
			end
			create_table User.table_name do |t|
				t.string :name
				t.timestamps
			end
			create_table ContactList.table_name do |t|
				t.integer :user_id
			end
		end

		def self.down
			drop_table User.table_name
			drop_table ContactList.table_name
			drop_table Contact.table_name
		end
	end
end

def Contacts.create
	puts 'Starting up'
	Contacts::Models::Base.establish_connection(
		:adapter =>'sqlite3',
		:database => 'data/contacts.db')
    	Contacts::Models.create_schema
end

Contacts.create
