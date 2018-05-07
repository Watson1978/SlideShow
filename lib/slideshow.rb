require_relative 'cocoa.bundle'

class Application
  class << self
    def setup
      @@app = Application.new
      yield @@app
    end

    def run
      @@app.run
    end
  end

  def photos=(array)
    paths = array.compact.map { |path|
      if !(path =~ /^https?/)
        path = "file://" + File.expand_path(path)
      end
      path
    }
    self.photo_paths = paths
  end
end