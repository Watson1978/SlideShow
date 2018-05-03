require './lib/slideshow.rb'

Application.setup do |app|
  app.title = 'Slide Show'
  app.interval = 5.0
  app.transition = :reveal # :fade, :move_in, :reveal のいずれか
  app.photos = Dir.glob("sample/*.jpg")
end

Application.run