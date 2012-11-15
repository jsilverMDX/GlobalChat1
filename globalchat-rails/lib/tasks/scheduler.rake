desc "This task is called by the Heroku cron add-on"
task :ping_nexus => :environment do
   uri = URI.parse('http://globalchatnet.herokuapp.com/')
   Net::HTTP.get(uri)
 end