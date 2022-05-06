require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'time'

def is_barber_exists?(db, name)
  db.execute('SELECT * FROM Barbers WHERE Name = ?', name).length.positive?
end

def seed_db(db, barbers)
  barbers.each do |barber|
    db.execute('INSERT INTO Barbers (Name) VALUES (?)', [barber]) unless is_barber_exists?(db, barber)
  end
end

def get_db
  db = SQLite3::Database.new 'db/BarberShop.db'
  db.results_as_hash = true
  db
end

before do
  db = get_db
  @barbers = db.execute 'SELECT * FROM Barbers'
end

configure do
  db = get_db
  db.execute "CREATE TABLE IF NOT EXISTS 'Users' (
    'Id'	INTEGER UNIQUE,
    'Name'	TEXT,
    'Phone'	TEXT,
    'Recording_date'	TEXT,
    'Barber'	TEXT,
    PRIMARY KEY('Id' AUTOINCREMENT)
  )"
  db.execute "CREATE TABLE IF NOT EXISTS 'Contacts' (
    'Id'	INTEGER UNIQUE,
    'Email'	TEXT,
    'Message'	TEXT,
    PRIMARY KEY('Id' AUTOINCREMENT)
  )"
  db.execute "CREATE TABLE IF NOT EXISTS 'Barbers' (
    'Id'	INTEGER UNIQUE,
    'Name'	TEXT,
    PRIMARY KEY('Id' AUTOINCREMENT)
  )"
  seed_db(db, ['Петр Петров', 'Иван Иванов', 'Сидор Сидоров', 'Семён Семёнов'])
end

def save_form_visit_to_database
  db = get_db
  db.execute 'INSERT INTO Users (Name, Phone, Recording_date, Barber)
  VALUES (?, ?, ?, ?)', [@username, @phone_number, @datetime, @barber]
  db.close
end

def save_form_contacts_to_database
  db = get_db
  db.execute 'INSERT INTO Contacts (Email, Message)
              VALUES (?, ?)', [@user_email, @comment]
  db.close
end

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

  hash_validation = { username: 'Введите имя',
                      phone_number: 'Введите номер телефона',
                      datetime: 'Выберите дату и время' }

  hash_validation.each do |key, _value|
    if params[key.to_sym] == '' || nil
      @error = hash_validation[key.to_sym]
      return erb :visit
    end
  end
  save_form_visit_to_database

  erb "Готово! Клиент: #{@username}, Номер телефона: #{@phone_number}, Дата и время: #{Time.parse(@datetime).strftime('%d-%m-%Y в %I:%M')}, Парикмахер: #{@barber} "
end

get '/contacts' do
  erb :contacts
end

post '/contacts' do
  @user_email = params[:user_email]
  @comment = params[:comment]
  save_form_contacts_to_database
  erb 'Готово!'
end

get '/showusers' do
  db = get_db

  @results = db.execute 'SELECT * FROM Users ORDER BY id DESC'

  erb :showusers
end
