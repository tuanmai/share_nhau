module Concerns
  module User
    module Facebook
      extend ActiveSupport::Concern

      def set_long_live_token
        if !expired_in || 2.days.from_now > expired_in
          @long_live_token = CGI::parse(HTTParty.get(facebook_graph_long_live_url).parsed_response)
          self.set token: @long_live_token['access_token'].first
          self.set expired_in: 60.days.from_now
        end
      end

      def sync_facebook_data
        data = HTTParty.get("https://graph.facebook.com//me/friends", :query => {access_token: token}, format: :json).parsed_response
        while data['paging'] && data['paging']['next'].present?
          self.friends_data |= data['data']
          next_url = data['paging']['next']
          data = HTTParty.get next_url
        end
        self.save

        friend_ids = self.friends_data.map { |f| f['id'] }
        system_friends = ::User.where(:fb_id.in => friend_ids)
        system_friends.each do |friend|
          UserFriend.create(user_1: self, user_2: friend)
        end
      end
    end
  end
end
