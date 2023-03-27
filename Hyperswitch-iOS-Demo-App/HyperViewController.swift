//
//  HyperViewController.swift
//  Hyperswitch-iOS-Demo-App
//
//  Created by harshit srivastava on 27/03/23.
//

import SwiftUI
import hyperswitch

class HyperBackendModel: ObservableObject {
    let backendCheckoutUrl = URL(string: "https://u4kkpaenwc.execute-api.ap-south-1.amazonaws.com/default/create-payment-intent")! // Your backend endpoint
    @Published var paymentSheet: HyperPaymentSheet?
    @Published var paymentResult: HyperPaymentSheetResult?
    
    func preparePaymentSheet() {
        let json: [String: Any] = ["amount": 6000,
                                   "currency": "USD",
                                   "confirm": false,
                                   "authentication_type":"no_three_ds",
                                   "shipping": [
                                    "address": [
                                        "line1": "1467",
                                        "line2": "Harrison Street",
                                        "line3": "Harrison Street",
                                        "city": "San Fransico",
                                        "state": "California",
                                        "zip": "94122",
                                        "country": "US",
                                        "first_name": "joseph",
                                        "last_name": "Doe"
                                    ],
                                    "phone": [
                                        "number": "8056594427",
                                        "country_code": "+91"
                                    ]
                                   ],
                                   "billing": [
                                    "address": [
                                        "line1": "1467",
                                        "line2": "Harrison Street",
                                        "line3": "Harrison Street",
                                        "city": "San Fransico",
                                        "state": "California",
                                        "zip": "94122",
                                        "country": "US",
                                        "first_name": "joseph",
                                        "last_name": "Doe"
                                    ],
                                    "phone": [
                                        "number": "8056594427",
                                        "country_code": "+91"
                                    ]
                                   ],
                                   "customer_id":"SaveCard",
                                   "capture_method":"automatic",
                                   "metadata": [
                                    "order_details": [
                                        "product_name": "Apple iphone 15,",
                                        "quantity": 1
                                    ]
                                   ]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: backendCheckoutUrl)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                  let paymentIntentClientSecret = json["clientSecret"] as? String,
                  let publishableKey = json["publishableKey"] as? String,
                  let self = self else {
                // Handle error
                return
            }
            
            STPAPIClient.shared.publishableKey = publishableKey
            var configuration = HyperPaymentSheet.Configuration()
            configuration.merchantDisplayName = "Example, Inc."
            configuration.allowsDelayedPaymentMethods = true
            DispatchQueue.main.async {
                self.paymentSheet = HyperPaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
            }
        })
        task.resume()
    }
    func onPaymentCompletion(result: HyperPaymentSheetResult) {
        self.paymentResult = result
    }
}
