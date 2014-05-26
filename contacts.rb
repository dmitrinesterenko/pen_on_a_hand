require 'camping'
require 'byebug'
Camping.goes :Contacts


module Contacts::Controllers
	class Index < R '/'
		def get
			#Time.now.to_s
			@time = Time.now.to_s
			@contacts = Contact.all(:order => 'updated_at DESC')
			       
			render :create_new
		end

		def post
			#@flash = "Note added"
			contact_list = Contacts::Models::Contact.new
    			#contact_list.user_id ='0' 
			#contact_list.email = 'email@mailinator.com'

			contact_list.note = input.notes
			contact_list.email = capture_email contact_list.note
			contact_list.save
			@contacts = Contact.all(:order => 'updated_at DESC')
			render :create_new
		end

		def capture_email(input)
    			email_match = /.*(\s[\w._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}).*/.match(input)
			if email_match.length > 0
				email_match[1]
			else
				''
			end
    		end
	end
	# This is computed every time, oh boy, it's much better to do these as
	# STATICS so that the value is computed once when the app is launched
	class Style < R '/uikit-2.6.0/(.*)'
	      	   def get(asset_path)
			asset = File.read(File.dirname(__FILE__)+'/uikit-2.6.0/'+asset_path).gsub(/.*__END__/m, '') 
		        @headers['Content-Type'] = 'text/css; charset=utf-8'
			asset
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
				title { "Pen a Note" }
				link :rel => 'stylesheet', :type => 'text/css', :href => "/uikit-2.6.0/css/uikit.css"
				script :src => "/uikit-2.6.0/js/uikit.js" 
			end
			body { self << yield }
		end
	end

	def create_new
		form :method=>'post' do
			input type: 'textarea', name: 'notes', value: '' 
			input type: 'submit', name: 'submit', value: 'Add'
		end	
		if @flash 
			#p @flash
		end
		@contacts.each do |contact|
			div contact.note.to_s 
			div contact.email.to_s
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

	class AddNoteField < V 1.1
		def self.up
			#change_table Contact.table_name do |t|
			add_column Contact.table_name, :note, :string, null: true
				
		end

		def self.down
			remove_column Contact.table_name, :note	
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
