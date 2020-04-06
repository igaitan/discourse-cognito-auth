# name: discourse-cognito-auth
# about: Authenticate with Cognito
# version: 0.1
# author: Abdullah Alhazmy
# url: https://github.com/alhazmy13/discourse-cognito-auth

enabled_site_setting :cognito_auth_enabled
enabled_site_setting :cognito_app_id
enabled_site_setting :cognito_secure_key
enabled_site_setting :cognito_aws_region
enabled_site_setting :cognito_user_pool_id

gem 'omniauth-cognito-idp', '0.1.1'

class Auth::CognitoAuthenticator < Auth::ManagedAuthenticator

  def name
    "cognitoidp"
  end

  def enabled?
    SiteSetting.cognito_auth_enabled
  end

  def register_middleware(omniauth)
    omniauth.provider :cognito_idp,
      name: :cognitoidp,
      verbose_logger: lambda {
        return unless SiteSetting.cognito_verbose_logging
        Rails.logger.warn("COGNITO-IDP Log: #{message}")
      },
      setup: lambda { |env|            
        opts = env['omniauth.strategy'].options

        opts.deep_merge!(
          client_id: SiteSetting.cognito_app_id,
          client_secret: SiteSetting.cognito_secure_key,
          scope: 'email openid aws.cognito.signin.user.admin profile',
          user_pool_id: SiteSetting.cognito_user_pool_id,
          aws_region: SiteSetting.cognito_aws_region,
          client_options: {
            site: SiteSetting.cognito_user_pool_site
          }
        )
      }
  end

  def description_for_user(user)
    Rails.logger.warn("COGNITO-IDP Log: description_for_user()")
    info = UserAssociatedAccount.find_by(provider_name: name, user_id: user.id)&.info
    return "" if info.nil?

    info["name"] || info["email"] || ""
  end

  def after_authenticate(auth_token, existing_account: nil)
    Rails.logger.warn("COGNITO-IDP Log: after_authenticate()")
    # Ignore extra data (we don't need it)
    auth_token[:extra] = {}
    super
  end
end

auth_provider frame_width: 920,
              frame_height: 800,
              authenticator: Auth::CognitoAuthenticator.new

register_svg_icon "fab fa-aws" if respond_to?(:register_svg_icon)

register_css <<CSS
.btn-social.cognito {
  background: #46698f;
}
CSS
