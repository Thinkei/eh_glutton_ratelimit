version = File.read(File.expand_path('../../VERSION', __FILE__))

exec("gem build eh_glutton_ratelimit.gemspec && curl -F package=@eh_glutton_ratelimit-#{version}.gem https://#{ENV['GEMFURY_TOKEN']}@push.fury.io/#{ENV['GEMFURY_PACKAGE']}/")
