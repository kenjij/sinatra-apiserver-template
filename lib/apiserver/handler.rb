module APIServer

  def self.handlers
    Handler.handlers
  end

  class Handler

    # Load handlers from directories designated in config
    def self.autoload
      APIServer.config.handler_paths.each { |path|
        load_from_path(path)
      }
    end

    # Load handlers from a directory
    # @param path [String] directory name
    def self.load_from_path(path)
      Dir.chdir(path) {
        Dir.foreach('.') { |f| load f unless File.directory?(f) }
      }
    end

    # Call as often as necessary to add handlers with blocks; each call creates an APIServer::Handler object
    # @param type [Symbol] :typea | :typeb | :typec
    # @param name [String]
    def self.add(type, name = nil, &block)
      @handlers ||= {
        typea: [],
        typeb: [],
        typec: []
      }
      @handlers[type] << Handler.new(type, name, &block)
      APIServer.logger.debug("Added #{type} handler: #{@handlers[type].last}")
    end

    # @return [Hash<Symbol, Array>] containing all the handlers
    def self.handlers
      @handlers
    end

    # Run the handlers, typically called by the server
    # @param data [Object] passed data
    def self.run(type, data)
      logger = APIServer.logger
      @handlers[type].each do |h|
        h.run(data)
      end
      logger.info("Done running #{type} handlers.")
    end

    attr_reader :type, :name

    def initialize(t, n = nil, &block)
      @type = t
      @name = n
      @block = block
    end

    def run(event)
      logger = APIServer.logger
      logger.warn("No block to execute for #{@type} handler: #{self}") unless @block
      logger.debug("Running #{@type} handler: #{self}")
    rescue => e
      logger.error(e.message)
      logger.error(e.backtrace.join("\n"))
    end

    def to_s
      "#<#{self.class}:#{self.object_id.to_s(16)}(#{name})>"
    end

  end

end
