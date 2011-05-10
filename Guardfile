# More info at http://github.com/guard/guard#readme

# I don't like ego (but it's useful)
guard 'ego' do
  watch('Guardfile')
end

# Everything doesn't need to be "reinvented" for node (e.g. what's the point of stylus & nib?)
guard 'compass', :configuration_file => "web/styles/compass.rb" do
  watch /^web\/styles\/(.*)\.s[ac]ss/
end

=begin
Because livereload is not ideal (see https://github.com/mockko/livereload/issues/26) ...
I experimented with this weirdo coffee / js workflow alternative:
* compile .coffee to .js with `cake assets:watch` (irrelevant errors with guard-coffeescript)
** node-dev reloads server.js dependencies (the requirements tree) - this takes some time ...
** guard-shell writes app/public/watch.coffee (with delay - allowance for node-dev server.js)
* cake compiles watch.coffee (step due to https://github.com/guard/guard-livereload/issues/4)
* guard-livereload catches the watch.js change so the browser can react (get the js reloaded)
This didn't quite work, so for now a ridiculous 1.8.7 install is preferable to the improbable 1.9.2
See wiki for more info.
=end

=begin

# the following stuff is kept for reference (of effort)

# it could be that blocks (do / end) cancels reloading (seemed so for watch.js)
guard 'livereload', :apply_js_live => false, :apply_css_live => false do
  watch('app/public/watch.js') do
    puts "Got watch.js time_stamp, livereloading..."
  end
  watch(%r{.+\.(css|html)}) do |m|
    puts "Detected #{m[1]} change, livereloading..."
  end
end

# two issues with guard-shell (feature request candidates)
# 1: it doesn't exclude watch.js - not sure what the more complicated regex would be like
# 2: it runs once for each file - not good in conjunction with sleep (prefer once for all)
guard 'shell' do
  watch(/((?!watch).)*\.js/) do |m|
    moment = Time.new
    delay = 3 # wait for server.js
    tock = "app/public/watch.coffee"
    puts "Reload in #{delay} seconds from #{moment} due to #{m[0]} change."
    sleep delay
    `echo "changes_timestamp = '#{moment}'" > #{tock}`
    puts "Wrote ticking #{tock} to trigger livereload."
  end
end

=end
