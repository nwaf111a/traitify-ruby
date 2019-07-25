module Traitify
  class Client
    module Connection
      def connection(options = {})
        Faraday::Utils.default_params_encoder = Faraday::FlatParamsEncoder

        Faraday.new(options) do |faraday|
          faraday.request :url_encoded
          faraday.request :basic_auth, secret_key || public_key, "x"
          faraday.headers["Accept"] = "application/json"
          faraday.headers["Content-Type"] = "application/json"
          faraday.use ErrorMiddleware
          faraday.response :json, :content_type => /\bjson$/
          faraday.adapter Faraday.default_adapter
        end
      end

      class ErrorMiddleware < Faraday::Middleware
        def initialize(app)
          @app = app
        end

        def call(env)
          @app.call(env).on_complete do |e|
            if error = Traitify::Error.from(e)
              raise error
            end
          end
        end
      end
    end
  end
end
