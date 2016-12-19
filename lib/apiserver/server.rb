require 'sinatra/base'
require 'apiserver/logger'
require 'apiserver/config'
require 'apiserver/helper'

module APIServer

  # The Sinatra server
  class Server < Sinatra::Base

    attr_reader :cmd_opts

    def initialize(opts)
      super()
      @cmd_opts = opts
      APIServer.load_config(opts[:config]) if opts[:config]
    end

    helpers Helper

    configure do
      set :environment, :production
      enable :logging
      disable :static, :dump_errors
    end

    before do
    end

    get '/:resource' do |r|
      json_with_object({resource: r})
    end

    get '/:resource/:id' do |r, id|
      json_with_object({resource: r, id: id, data: {text: "A text.", date: Time.now()}})
    end

    not_found do
      json_with_object({message: 'Huh, nothing here.'})
    end

    error 401 do
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
