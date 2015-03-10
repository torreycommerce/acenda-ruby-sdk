module URI
  remove_const :DEFAULT_PARSER
  unreserved = REGEXP::PATTERN::UNRESERVED
  DEFAULT_PARSER = Parser.new(:UNRESERVED => unreserved + "\{\}")
end

module Acenda
    class APIErrorHTTP < StandardError; end
    class Response
        require 'json'

        def initialize(response, url="", params=[])
            @response = treat_response(response)
            @url = url
            @params = params
        end

        def get_url()
            return @url
        end

        def get_params()
            return @params
        end

        def get_result()
            return @response[:result]
        end

        def get_number()
            return @response[:num_total]
        end

        def get_code()
            raise Acenda::APIErrorHTTP, "Request didn't go through and error cannot be parsed." if @response[:code].to_i == 0
            return @response[:code].to_i
        end

        def get_status()
            return @response[:status]
        end

        private

            def treat_response(http_response)
                if http_response.class == String
                    return symbolize_result(JSON.parse(http_response))
                else
                    return {
                        :result => symbolize_result(JSON.parse(http_response.body)),
                        :code => http_response.code().to_i,
                        :num_total => 1,
                        :status => http_response.message()
                    }
                end

            end

            def symbolize_result(source)
                dest = source.is_a?(Array) ? [] : {}

                source.each_with_index { |(key,value), index|
                    k = key.is_a?(String) ? key.to_sym : key
                    if value.is_a? Hash or value.is_a? Array
                        dest[k] = symbolize_result(value)
                    else
                        dest[k] = value
                    end
                } if source.is_a? Hash

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
                :store_url => store_url + (store_url.split('').last == '/' ? 'api' : '/api'),
                :access_token => nil
            }

            case ENV["ACENDA_MODE"]
            when "acendavm"
                @config[:acenda_api_url] = "http://acenda.acendev"
            when "development"
                @config[:acenda_api_url] = "http://acendan.devserver"
            else
                @config[:acenda_api_url] = "http://acenda.com"
            end
        end

        def query(verb, uri, params=nil)
            generate_token() if (!@config[:access_token])
            obj = nil
            query = nil

            case verb
            when "GET"
                query = generate_query(uri, params)
                obj = Net::HTTP.get(query)
            when "POST"
                raise ArgumentError, 'Acenda::API -- Parameters is not a Hash' unless params.is_a? Hash
                query = generate_query(uri)
                obj = Net::HTTP.post(query, params)
            when "PUT"
                raise ArgumentError, 'Acenda::API -- Parameters is not a Hash' unless params.is_a? Hash
                query = generate_query(uri)
                obj = Net::HTTP.put(generate_query(uri), params)
            when "DELETE"
                query = generate_query(uri, params)
                obj = Net::HTTP.delete(query)
            end

            return Acenda::Response.new(obj, query, params)
        end

        private
            @config = {}

            def generate_query(uri, params)
                params ||= {}
                params = params.merge :access_token => @config[:access_token]

                parameters = ""
                params.each_with_index do |(k,v), i|
                    parameters += "&" unless i < 1
                    parameters += k.to_s+"="+v.to_s
                end if params != ""

                # @route = URI(URI.escape(@config[:store_url]+(uri.split('').first == '/' ? uri : '/'+uri+("?")+parameters)))
                @route = @config[:store_url]
                @route += (uri.split('').first == '/') ? uri : '/'+uri
                @route += (uri.count('?') > 0 ? '&' : '?')+parameters
                @route = URI(@route)

                return @route
            end

            def generate_token()
                response = Acenda::Response.new Net::HTTP.post_form(URI(@config[:acenda_api_url]+"/oauth/token"),{
                    "client_id" => @config[:client_id],
                    "client_secret" => @config[:client_secret],
                    "grant_type" => "client_credentials"}
                )

                @config[:access_token] = response.get_result()[:access_token] unless response.get_code() != 200
                raise Acenda::APIErrorHTTP, "Token generation failed #{response.get_code()}" if response.get_code() != 200
            end
    end
end
