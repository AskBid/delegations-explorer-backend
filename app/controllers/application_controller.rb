class ApplicationController < ActionController::API
  before_action :authorized

  def authorized
    render json: { message: 'Please log in' }, 
       status: :unauthorized unless logged_in?
  end

  def logged_in?
    !!current_user
  end

  def current_user
    if decoded_token()
       user_id = decoded_token[0]['user_id']
       @user = User.find_by(id: user_id)
    end
  end

  def decoded_token
    if auth_header()
       begin
          JWT.decode(auth_header(), "#{ENV['SECRET_KEY_BASE']}", true, algorithm: 'HS256')
       rescue JWT::DecodeError
          nil
       end
    end
  end

  def auth_header
    request.headers['Authorization']
  end

  def encode_token(payload)
    JWT.encode(payload, "#{ENV['SECRET_KEY_BASE']}")
  end

  def render_user
    @token = encode_token(user_id: @user.id)
    render json: UserSerializer.new(@user).to_login_json(token: @token, errors: @user.errors.messages)
  end
end
