class UserSerializer
  def initialize(user)
    @user=user
  end

  def to_login_json(**additional_hash)
    options ={
      only: [:username, :id]
    }

    @user.as_json(options).merge(additional_hash)
  end

  def to_serialized_json()
    options ={
      include: {
		    stakes: {only: [:address, :species]},
        followed_pools: {only: :ticker}
		  }, except: [:updated_at, :created_at, :password_digest]
    }

    @user.as_json(options)
  end
end