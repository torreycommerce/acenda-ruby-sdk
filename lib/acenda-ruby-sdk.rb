module Acenda
    class Response
        require 'json'

        def initialize(response)
            @response = symbolize_result(JSON.parse(response))
        end

        def get_result()
            return @response[:result]
        end

        def get_number()
            return @response[:num_total]
        end

        def get_status_code()
            return @response[:code]
        end

        def get_status()
            return @response[:status]
        end

        private
            @response = {}

            def symbolize_result(source)
                dest = source.is_a?(Array) ? [] : {}

                source.each_with_index { |(key,value), index|
                    k = key.is_a?(String) ? key.to_sym : key
                    if value.class == Object or value.class == Array
                        dest[k] = symbolize_result(value)
                    else
                        dest[k] = value
                    end
                } if source.class == Hash

                source.each_with_index { |value, index|
                    dest[index] = symbolize_result(value)
                } if source.class == Array

                return dest
            end
    end

    class API
        require 'uri'
        require 'net/http'

        def initialize(client_id, client_secret, store_url)
            @config = {
                :client_id => client_id,
                :client_secret => client_secret,
                :store_url => store_url + (store_url.split('').last == '/' ? 'api' : '/api')
            }
        end

        def query(verb, uri, params=nil)
            obj = nil

            case verb
            when "GET"

                obj = Net::HTTP.get(generate_query(uri))
            when "POST"
                raise ArgumentError, 'Acenda::API -- Parameters is not a Hash' unless params.is_a? Hash
                obj = Net::HTTP.post(generate_query(uri))
            when "PUT"
                raise ArgumentError, 'Acenda::API -- Parameters is not a Hash' unless params.is_a? Hash
                obj = Net::HTTP.put(generate_query(uri))
            when "DELETE"
                obj = Net::HTTP.delete(generate_query(uri))
            end

            return Acenda::Response.new(obj)
        end

        private
            @config = {}

            def generate_query(uri)
                return URI(@config[:store_url]+(uri.split('').first == '/' ? uri : '/'+uri))
            end
    end
end
