class StakeSerializer
  def initialize(stake)
    @stake=stake
  end

  def to_serialized_json()
    options ={
        include: {
          pool: {only: :ticker},
          stake: {only: :address}
        }, 
        only: [:amount, :rewards, :epochno]
    }

    @stake.as_json(options)
  end
end