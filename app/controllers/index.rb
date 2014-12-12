get '/' do
  # Look in app/views/index.erb
  erb :index
end

post '/tweets' do
  # Look in app/views/index.erb
  # puts params
  $client.update(params[:tweet])
  erb :result, layout: false
end