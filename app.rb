require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb 'Hello! <a href="https://github.com/bootstrap-ruby/sinatra-bootstrap">Original</a> pattern has been modified for <a href="http://rubyschool.us/">Ruby School</a>'
end

get '/about' do
  erb :about
end

get '/contacts' do
  erb :contacts
end

get '/visit' do
  erb :visit
end

post '/visit' do
  erb :visit
end

post '/' do
  @user_name = params[:user_name]
  @phone = params[:phone]
  @date_time = params[:date_time]
  @baber = params[:barber]

  @title = 'Thank you!'
  @message = "Уважаемый #{@user_name}, мы ждём вас #{@date_time} у выбранного парикмахера #{@barber}."

  f = File.open 'users.txt', 'a'
  f.write "User: #{@user_name}, phone: #{@phone}, date and time: #{@date_time}. Baber: #{@barber}.\n"
  f.close

  erb :message
end
