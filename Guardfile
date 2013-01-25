# More info at http://github.com/guard/guard#readme

# Everything doesn't need to be "reinvented" for node.
# What's the point of stylus and nib?  Inferior, so far.
guard 'compass', :configuration_file => "web/styles/compass.rb" do
  watch /^web\/styles\/(.*)\.s[ac]ss/
end

# Chrome-based web development.
# Must install LiveReload extension.
guard 'livereload',
      :api_version => '1.6',
      :grace_period => 0.0,
      :apply_js_live => true,
      :apply_css_live => true do
  watch %r{web/.+\.coffee}
  watch %r{web/views/.+\.jade}
  watch %r{web/public/css/.+\.css}
end

