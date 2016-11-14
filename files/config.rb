# Monkey patch : Removes all comments completely
class Sass::Tree::Visitors::Perform < Sass::Tree::Visitors::Base
  def visit_comment(node)
    return []
  end
end

# Compass config
http_path = "/"
css_dir = "assets/css"
sass_dir = "assets/scss"
images_dir = "assets/images"
javascripts_dir = "assets/js"
output_style = :compact
relative_assets = true
line_comments = false
preferred_syntax = :scss
