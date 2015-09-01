
require_relative 'rolodex'

require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, "sqlite3:database.sqlite3")

class Contact
  include DataMapper::Resource

  property :id, Serial
  property :first_name, String
  property :last_name, String
  property :email, String
  property :note, String
end

DataMapper.finalize
DataMapper.auto_upgrade!



#   attr_accessor :id, :first_name, :last_name, :email, :note

#   def initialize(first_name, last_name, email, note)
#     @first_name = first_name
#     @last_name = last_name
#     @email = email
#     @note = note
#   end
# end


$rolodex= Rolodex.new

get "/contacts/1000" do
  @contact = $rolodex.find(1000)
  erb :show_contact
end

get '/contacts/new' do

  erb :new_contact
end

get '/' do
  @crm_app_name = "My CRM App"
  erb :index
end

get '/contacts' do
  erb :contacts
end

get "/contacts/:id" do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    erb :show_contact
  else
    raise Sinatra::NotFound
  end
end

get "/contacts/:id" do
  @contact = Contact.get(params[:id].to_i)
if @contact
    erb :show_contact
  else
    raise Sinatra::NotFound
  end
end

# get "/contacts/:id/edit" do
#   erb :edit_contact
# end

get "/contacts" do
  @contacts = Contact.all
  erb :contacts
end

get '/contacts/new' do
  erb :new_contact
end

get "/contacts/:id" do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    erb :show_contact
  else
    raise Sinatra::NotFound   
  end 
end

get "/contacts/:id/edit" do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    erb :edit_contact
  else
    raise Sinatra::NotFound
  end
end

put "/contacts/:id" do
  @contact = Contact.get(params[:id].to_i)
  if @contact
      @contact.update(:fname => params[:fname],
      :lname => params[:lname],
      :email => params[:email],
      :note => params[:note]
      )

    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end

delete "/contacts/:id" do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    @contact.destroy
    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end
post "/contacts" do
  contact = Contact.create(
    :first_name => params[:first_name],
    :last_name => params[:last_name],
    :email => params[:email],
    :note => params[:note]
  )
  redirect to('/contacts')
end