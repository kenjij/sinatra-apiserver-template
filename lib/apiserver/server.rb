require 'sinatra/base'
require 'apiserver/helper'

module APIServer

  # The Sinatra server
  class Server < Sinatra::Base

    helpers Helper

    configure do
      set :environment, :production
      disable :static
      c = Config.shared
      set :dump_errors, c.dump_errors
      set :logging, c.logging
      c.run_post_boot
    end

    before do
      tokens = Config.shared.auth_tokens
      halt 401 unless tokens.empty? || tokens.include?(params[:auth])
    end

    get '/:resource' do |r|
      json_with_object({resource: r})
    end

    get '/:resource/:id' do |r, id|
      json_with_object({resource: r, id: id, data: {text: "A text.", date: Time.now()}})
    end

    post '/:resource' do |r|
      APIServer.logger.info('Incoming request received.')
      APIServer.logger.debug("Body size: #{request.content_length} bytes")
      request.body.rewind
      hash = parse_json(request.body.read)
      json_with_object({resource: r, data: hash})
    end

    not_found do
      APIServer.logger.info('Invalid request.')
      APIServer.logger.debug("Request method and path: #{request.request_method} #{request.path}")
      json_with_object({message: 'Huh, nothing here.'})
    end

    error 401 do
      APIServer.logger.info(params[:auth] ? 'Invalid auth token provided.' : 'Missing auth token.')
      APIServer.logger.debug("Provided auth token: #{params[:auth]}") if params[:auth]
      json_with_object({message: 'Oops, need a valid auth.'})
    end

    error do
      status 500
      err = env['sinatra.error']
      APIServer.logger.error "#{err.class.name} - #{err}"
      json_with_object({message: 'Yikes, internal error.'})
    end

    after do
      content_type 'application/json'
    end

  end
end
