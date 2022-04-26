require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

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
  @username = params[:username].strip
  @phone_number = params[:phone_number].strip
  @datetime = params[:datetime]
  @barber = params[:barber]
  db = SQLite3::Database.new 'barbershop-sinatra/db/BarberShop.db'
  db.execute "INSERT INTO Users (Name, Phone, Recording_date, Barber)
              VALUES ('#{@username}', '#{@phone_number}', '#{@datetime}', '#{@barber}')"
  db.close

  hash_validation = { username: 'Введите имя',
                      phone_number: 'Введите номер телефона',
                      datetime: 'Выберите дату и время' }

  hash_validation.each do |key, _value|
    if params[key.to_sym] == ''
      @error = hash_validation[key.to_sym]
      return erb :visit
    end
  end
  erb "Готово! Клиент: #{@username}, Номер телефона: #{@phone_number}, Дата и время: #{@datetime}, Парикмахер: #{@barber} "
end

get '/contacts' do
  erb :contacts
end

post '/contacts' do
  @user_email = params[:user_email]
  @comment = params[:comment]
  db = SQLite3::Database.new 'barbershop-sinatra/db/BarberShop.db'
  db.execute "INSERT INTO Contacts (Email, Message)
              VALUES ('#{@user_email}', '#{@comment}')"
  db.close
  erb 'Готово!'
end
