class PoolSerializer
  def initialize(user)
    @user=user
  end

  def to_serialized_json(**additional_hash)
    options ={
      only: [:ticker, :id, :poolid]
    }

    @user.as_json(options).merge(additional_hash)
  end
end