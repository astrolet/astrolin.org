# config:
public_dir = "web/public"
sass_dir = "web/styles"
http_path = "/"
http_stylesheets_path = "css"
http_images_path = "img"
http_javascripts_path = "js"
css_dir = "#{public_dir}/#{http_stylesheets_path}"
images_dir = "#{public_dir}/#{http_images_path}"
javascripts_dir = "#{public_dir}/#{http_javascripts_path}"
project_type = :stand_alone
output_style = :compressed
#relative_assets = true
preferred_syntax = :sass

require "susy"

