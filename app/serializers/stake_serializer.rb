class StakeSerializer
  def initialize(stake)
    @stake=stake
  end

  def to_serialized_json()
    options ={
      only: [:address, :id]
    }

    @stake.as_json(options)
  end
end