class ActiveStakeSerializer
  def initialize(stake)
    @stake=stake
  end

  def to_serialized_json()
    options ={
        include: {
          pool: {only: [:ticker, :id, :poolid]},
          stake: {only: [:address, :id]}
        }, 
        only: [:amount, :rewards, :epochno]
    }

    @stake.as_json(options)
  end
end