class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  # Service entry point - return valid user object
  def call
    {
      user: user
    }
  end

  protected

  def sign_out(resource_or_scope = nil)
    @user.update_attributes(current_sign_in_at: nil) if @user.present?
    super
  end

  private

  attr_reader :headers

  def user
    # check if user is in the database
    # memoize user object
    @user ||= User.find(decoded_auth_token["id"]) if decoded_auth_token

    # Ensure the token is invalid if user signed-out before
    # @user = nil if decoded_auth_token['iat'] != @user.current_sign_in_at.to_i
    # handle user not found
  rescue ActiveRecord::RecordNotFound => e
    # raise custom error
    raise(
      ExceptionHandler::InvalidToken,
      ("#{I18n.t('errors.messages.invalid_token')} #{e.message}")
    )
  end

  # decode authentication token
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  # check for token in `Authorization` header
  def http_auth_header
    if auth_present?
      return headers['Authorization'].scan(/Bearer (.*)$/).flatten.last
    end

    raise(ExceptionHandler::MissingToken, I18n.t('errors.messages.missing_token') )
  end

  def auth_present?
    !!headers.fetch("Authorization", "").to_s.scan(/Bearer/).flatten.first
  end
end
