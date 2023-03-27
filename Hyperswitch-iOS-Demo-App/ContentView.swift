//
//  ContentView.swift
//  Hyperswitch-iOS-Demo-App
//
//  Created by Harshit Srivastava on 14/04/23.
//

import SwiftUI
import HyperswitchCore

struct ContentView: View {
    @State private var selectedSegment = 0
    
    var body: some View {
        VStack {
            Picker(selection: $selectedSegment, label: Text("")) {
                Text("UIKit View").tag(0)
                Text("SwiftUI View").tag(1)
            }.pickerStyle(SegmentedPickerStyle())
            if selectedSegment == 0 {
                UIKitView()
            } else {
                SwiftUIView()
            }
        }
    }
}

struct UIKitView: UIViewControllerRepresentable {
    typealias UIViewControllerType = PaymentViewController
    
    func makeUIViewController(context: Context) -> PaymentViewController {
        let vc = PaymentViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: PaymentViewController, context: Context) {
    }
}

struct SwiftUIView: View {
    @State var showingDetail = false
    @ObservedObject var hyperModel = HyperBackendModel()
    @State var paymentMethodParams: STPPaymentMethodParams?
    @State var isConfirmingPayment = false
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            LazyVStack(spacing: 40) {
                
                VStack(spacing: 20.0) {
                    Text("Hyper Element")
                    STPPaymentCardTextField.Representable(paymentMethodParams: $paymentMethodParams)
                        .padding()
                    let paymentIntent = STPPaymentIntentParams(clientSecret: hyperModel.paymentIntentClientSecret ?? "")
                    Button("Pay")
                    {
                        paymentIntent.paymentMethodParams = paymentMethodParams
                        isConfirmingPayment = true
                    }
                    .paymentConfirmationSheet(
                        isConfirmingPayment: $isConfirmingPayment,
                        paymentIntentParams: paymentIntent,
                        onCompletion: hyperModel.onCompletion
                    )
                }
                VStack(spacing: 40) {
                    if let paymentSheet = hyperModel.paymentSheet {
                        PaymentSheet.PaymentButton(paymentSheet: paymentSheet, onCompletion: hyperModel.onPaymentCompletion) {
                            Text("Hyper Payment Sheet")
                                .padding()
                                .background(Color.blue)
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
}
