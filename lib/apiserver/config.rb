module APIServer

  # Load Ruby config file
  # @param path [String] config file
  def self.load_config(path)
    raise 'config file missing' unless path
    require File.expand_path(path)
  end

end
