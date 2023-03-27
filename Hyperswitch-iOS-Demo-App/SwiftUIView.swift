//
//  SwiftUIView.swift
//  Hyperswitch-iOS-Demo-App
//
//  Created by harshit srivastava on 27/03/23.
//

import SwiftUI
import hyperswitch

struct SwiftUIButtonView: View {
    @ObservedObject var hyperModel = HyperBackendModel()
     var paymentSheet: HyperPaymentSheet?
     var paymentResult: HyperPaymentSheetResult?
    
    var body: some View {
        NavigationView {
            VStack (spacing: 20) {
                
                VStack {
                    if hyperModel.paymentSheet == nil {
                        Text("Please wait ...")
                            .padding()
                            .foregroundColor(.white)
                            .cornerRadius(10.0)
                            .clipShape(Capsule())
                            .frame(maxWidth: 320, alignment: .center)
                            .padding(.init(top: 15, leading: 0, bottom: 15, trailing: 0))
                    }
                    else{
                        if let paymentSheet = hyperModel.paymentSheet {
                            HyperPaymentSheet.PaymentButton(paymentSheet: paymentSheet, onCompletion: hyperModel.onPaymentCompletion) {
                                Text("Hyper Payment Sheet")
                                    .padding()
                                    .foregroundColor(.white)
                                    .cornerRadius(10.0)
                            }
                            
                            if let result = hyperModel.paymentResult {
                                switch result {
                                case .completed:
                                    Text("Payment complete")
                                case .failed(let error):
                                    Text("Payment failed: \(error.localizedDescription)")
                                case .canceled:
                                    Text("Payment canceled.")
                                }
                            }
                        }
                    }
                }.onAppear { hyperModel.preparePaymentSheet() }
            }
        }
    }}

