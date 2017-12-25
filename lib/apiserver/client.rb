require 'eventmachine'
require 'em-http'

module APIServer
  class HTTPClient
    def self.post_form(url:, params: nil, head: nil, &block)
      if EM.reactor_running?
        APIServer.logger.debug("POSTing form to #{url}")
        APIServer::HTTPClient.request(url: url, head: head, body: params, &block)
      else
        APIServer.logger.debug('Starting reactor...')
        EM.run do
          APIServer.logger.debug("POSTing form to #{url}")
          APIServer::HTTPClient.request(url: url, head: head, body: params, stop: true, &block)
        end
      end
    end

    def self.post_json(url:, params: nil, body: nil, head: {}, &block)
      head['Content-Type'] = 'application/json; charset=utf-8'
      body = Helper.json_with_object(params) if params
      if EM.reactor_running?
        APIServer.logger.debug("POSTing JSON to: #{url}")
        APIServer::HTTPClient.request(url: url, head: head, body: body, &block)
      else
        APIServer.logger.debug('Starting reactor...')
        EM.run do
          APIServer.logger.debug("POSTing JSON to #{url}")
          APIServer::HTTPClient.request(url: url, head: head, body: body, stop: true, &block)
        end
      end
    end

    def self.request(url:, head: nil, body:, stop: false, &block)
      http = EM::HttpRequest.new(url).post(body: body, head: head)
      http.errback do
        APIServer.logger.error('HTTP error')
        if stop
          EM.stop
          APIServer.logger.debug('Stopped reactor.')
        end
      end
      http.callback do
        block.call(http) if block_given?
        if stop
          EM.stop
          APIServer.logger.debug('Stopped reactor.')
        end
      end
    end
  end
end
