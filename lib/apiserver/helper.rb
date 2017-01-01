require 'json'
require 'time'

module APIServer

  module Helper

    def parse_json(json)
      obj = JSON.parse(json)
      return keys_to_sym(obj)
    end

    # Convert all Hash keys to lowercase symbols
    # @param obj [Object] any Ruby object
    def keys_to_sym(obj)
      case obj
      when Array
        obj.each do |v|
          keys_to_sym(v)
        end
      when Hash
        obj.keys.each do |k|
          if k.class == String
            obj[k.downcase.to_sym] = keys_to_sym(obj.delete(k))
          end
        end
      end
      return obj
    end

    # Convert object into JSON, optionally pretty-format
    # @param obj [Object] any Ruby object
    # @param opts [Hash] any JSON options
    # @return [String] JSON string
    def json_with_object(obj, pretty: true, opts: nil)
      return '{}' if obj.nil?
      if pretty
        opts = {
          indent: '  ',
          space: ' ',
          object_nl: "\n",
          array_nl: "\n"
        }
      end
      JSON.fast_generate(json_format_value(obj), opts)
    end

    # Return Ruby object/value to JSON standard format
    # @param val [Object]
    # @return [Object]
    def json_format_value(val)
      case val
      when Array
        val.map { |v| json_format_value(v) }
      when Hash
        val.reduce({}) { |h, (k, v)| h.merge({k => json_format_value(v)}) }
      when String
        val.encode!('UTF-8', {invalid: :replace, undef: :replace})
      when Time
        val.utc.iso8601
      else
        val
      end
    end

  end

end
