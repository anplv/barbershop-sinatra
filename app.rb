require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb 'Hello! <a href="https://github.com/bootstrap-ruby/sinatra-bootstrap">Original</a> pattern has been modified for <a href="http://rubyschool.us/">Ruby School</a>'
end

get '/about' do
  erb :about
end

get '/visit' do
  erb :visit
end

post '/visit' do
  @username = params[:username]
  @datetime = params[:datetime]
  @barber = params[:barber]
  f = File.new('users.txt', 'a')
  f.write "Клиент: #{@username},\n Дата и время: #{@datetime},\n Парикмахер: #{@barber} \n"
  f.close
  erb :visit
end

get '/contacts' do
  erb :contacts
end

post '/contacts' do
  @user_email = params[:user_email]
  @comment = params[:comment]
  f = File.new('contacts.txt', 'a')
  f.write "Email: #{@user_email},\n Комментарий: #{@comment}\n"
  f.close
  erb :contacts
end
