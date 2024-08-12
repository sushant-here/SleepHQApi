![alt text](sleepHQ.svg "SleepHQ Logo")

# SleepHQApi for Swift (Unofficial)
This is a lightweight 3rd party swift package for accessing the [SleepHQ Api](https://sleephq.com/api-docs/index.html) from within a Swift application.

## Example 

```
let api: SleepHQApi = SleepHQProdApi()
let authResponse = try await api.auth(.init(clientId: "xxx",
                                            clientSecret: "xxx"))
let me = try await api.whoami()
me.data.email
```

You can obtain your API key by going into the Account Settings page on the [SleepHQ](https://sleephq.com/account) dashboard. As of August 2024 - you are required to be on the `SleepHQ Pro Plan` in order to generate a API key.

## Community and support
No warranty is given for using this project. Support can be discussed / provided by reaching out by raising a issue. Even better - feel free to contribute back to this repo by raising a pull request! 
