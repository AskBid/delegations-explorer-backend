class UserSerializer
  def initialize(user)
    @user=user
  end

  def to_serialized_json
    options ={
      include: {
        followed_pools:{
          only: [:ticker]
        },
        active_stakes:{
          only: [:address]
        }
      }
    }

    @user.to_json(options)
  end
end
