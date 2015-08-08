module Concerns
  module User
    module Facebook
      extend ActiveSupport::Concern

      def set_long_live_token
        if !expired_in || 2.days.from_now > expired_in
          @long_live_token = CGI::parse(HTTParty.get(facebook_graph_long_live_url))
          self.set :token, @long_live_token['access_token'].first
          self.set :expired_in, 60.days.from_now
        end
      end

      def sync_facebook_data
      end
    end
  end
end
