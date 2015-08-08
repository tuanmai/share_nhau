module Services
  module User
    class FacebookCreator < Services::Base
      ATTRIBUTES = []
      attr_accessor *ATTRIBUTES, :user, :oauth_token, :errors

      def initialize(facebook_token, options = {})
        self.oauth_token = facebook_token
        assign_attributes(options.slice(*ATTRIBUTES))
      end

      def create_new_user
        new_user = ::User.new(default_params.merge(facebook_account_params))
        new_user.save!
        new_user
      end

      def facebook_account_params
        {
          fb_id: facebook_id,
          token: oauth_token,
        }
      end

      def default_params
        {
          password: Devise.friendly_token[0,20],
          email: user_email,
          name: user_name,
          meta: {
            first_contact: Time.now,
            facebook_connected: Time.now,
          },
        }
      end

      def facebook_graph_url
        "https://graph.facebook.com/me?&access_token=#{oauth_token}"
      end

      def facebook_id
        user_info["id"]
      end

      def find_or_create
        self.user = ::User.where(fb_id: facebook_id).first

        if self.user
          self.user.set(token: facebook_account_params[:token])
          self.user.set_long_live_token
        else
          self.user = create_new_user
          self.user.sync_facebook_data
        end

        self.user
      end

      %w(name email).each do |field|
        define_method "user_#{field}" do
          user_info[field]
        end
      end

      def user_info
        @user_info ||= HTTParty.get(facebook_graph_url).parsed_response
      end
    end
  end
end
