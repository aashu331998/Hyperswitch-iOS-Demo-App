//
//  HyperBackendModel.swift
//  Hyperswitch-iOS-Demo-App
//
//  Created by Harshit Srivastava on 14/04/23.
//

import SwiftUI
import HyperswitchCore

class HyperBackendModel: ObservableObject {
    
    let backendCheckoutUrl = URL(string: "http://localhost:4444/create-payment")!   // Your backend endpoint
    
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    @Published var paymentIntentClientSecret: String?
    @Published var paymentStatus: STPPaymentHandler.STPPaymentHandlerActionStatus?
    
    func preparePaymentSheet() {
        // MARK: Fetch the PaymentIntent from the backend
        var request = URLRequest(url: backendCheckoutUrl)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                  let paymentIntentClientSecret = json["clientSecret"] as? String,
                  let self = self else {
                // Handle error
                return
            }
            
            STPAPIClient.shared.publishableKey = "<PUBLISHABLE_KEY>" // Your publishable key endpoint
            var configuration = PaymentSheet.Configuration()
            configuration.merchantDisplayName = "Example, Inc."
            configuration.allowsDelayedPaymentMethods = true
            DispatchQueue.main.async {
                self.paymentIntentClientSecret = paymentIntentClientSecret
                self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
            }
        })
        task.resume()
    }
    func onPaymentCompletion(result: PaymentSheetResult) {
        DispatchQueue.main.async {
            self.paymentResult = result
        }
    }
    func onCompletion(status: STPPaymentHandler.STPPaymentHandlerActionStatus, pi: STPPaymentIntent?, error: NSError?) {
        DispatchQueue.main.async {
            self.paymentStatus = status
        }
    }
}
