# Delegation Explorer Backend

This backend serves [delegations-explorer-frontend](https://github.com/AskBid/delegations-explorer-frontend).

Delegation Explorer Backend queries through Rake tasks a GraphQL API to populate its database.
The GraphQL API is maintened from a [`cardano-graphql`](https://github.com/input-output-hk/cardano-graphql) node. This is a node that reads the Cardano Blockchain building a postgress database that can be queried through the API.
A natural development of this repository would be to connect the Rails app directly to a [`cardano-db-sync`](https://github.com/input-output-hk/cardano-db-sync) which maintannes a postgresql database that coudl be the Rails app database itself.

Sometime a reward address can be different from the owner and comes from a wallet that may not be delegated. That means that a reward is not associated to any pool and a stake address was not saved. In order to understand what Pool this reward address belongs to, we have to look into the Owners of each Pool. Those owners are kept as `hash` and not `bech32` format. For this reason I have created a little Rails App API [`bech32-converter-api`](https://github.com/AskBid/bech32-converter-api) that converts from and to `bech32` cardano addresses.
Once the servers for GraphQL API and bech32 Concerter are set up the relative URLs must be saved as ENV variables as follows:
```
IP_CARDANO_GRAPHQL_API_SERVER
LOCALTUNNEL_URL
SECRET_KEY_BASE
```
The last variable is relative to JWT token secret which is used for user authentication.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AskBid/cafes-rota. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The repository is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT)