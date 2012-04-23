# More info at http://github.com/guard/guard#readme

# I don't like ego, but it can be useful.
guard 'ego' do
  watch('Guardfile')
end

# Everything doesn't need to be "reinvented" for node.
# What's the point of stylus and nib?  Inferior, so far.
guard 'compass', :configuration_file => "web/styles/compass.rb" do
  watch /^web\/styles\/(.*)\.s[ac]ss/
end

