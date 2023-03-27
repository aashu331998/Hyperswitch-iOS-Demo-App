# Hyperswitch-iOS-Demo-App

A simple iOS app to demo the new hyperswitch SDK

## Running the sample App

1. Build the application

2. Provide valid API key in server/server.js and Publishable key in HyperBackendModel.swift. You can create your keys using the Hyperswitch dashboard. https://app.hyperswitch.io/

> Note: You can checkout the live demo app on testflight here. https://testflight.apple.com/join/WhPLmrT6

```js
//in server/server.js
const hyper = require("@juspay-tech/hyperswitch-node")("<API-KEY>");
```

```swift
//in HyperBackendModel.swift add your publishable key
STPAPIClient.shared.publishableKey = "<PUBLISHABLE_KEY>"
```

3. Run the Server

```bash
cd server
npm install
```

```bash
#run the server

node server.js
```

4. Run the application

```bash
pod install
```

```bash
xed . 

# or open .xcworkspace file
```
