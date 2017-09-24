require 'sinatra'
require 'pg'
load './local_env.rb' if File.exist?('./local_env.rb')

    db_params = {
	    host: ENV['host'],
	    port: ENV['port'],
	    dbname: ENV['db_name'],
	    user: ENV['user'],
	    password: ENV['password']
    }

    db = PG::Connection.new(db_params)

get '/' do 
	erb :index, :locals => {:message => ""}
end
get '/index' do 
	mywebsite = db.exec("SELECT full_name, email, message FROM mywebsite");
	erb :index
end

post '/mywebsite' do 
	full_name = params[:full_name]
	email = params[:email]
	message = params[:message]
	check_email = db.exec("SELECT * FROM mywebsite WHERE email = '#{email}'")
	if check_email.num_tuples.zero? == false
		erb :index, :locals => {:message => "Email already exists"}
	else
	    db.exec("INSERT INTO mywebsite(full_name, email, message) VALUES('#{full_name}', '#{email}', '#{message}')");
	    erb :index, :locals => {:message => "Thankyou for sending Feedback."}
    end
end

post '/mywebsite' do 
	erb :index
end

get '/index' do 
	erb :index, :locals => {:message => ""}
end
get '/projects' do
  erb :projects
end