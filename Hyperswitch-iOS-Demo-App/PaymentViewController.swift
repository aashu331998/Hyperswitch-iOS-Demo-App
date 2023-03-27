//
//  PaymentViewController.swift
//  Hyperswitch-iOS-Demo-App
//
//  Created by Harshit Srivastava on 14/04/23.
//

import UIKit
import SwiftUI
import HyperswitchCore

class PaymentViewController: UIViewController {
    
    @ObservedObject var hyperModel = HyperBackendModel()
    
    
    var statusLabel = UILabel()
    var paymentSheetButton = UIButton()
    
    let hyperLabel = UILabel()
    
    lazy var hyperCardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        return cardTextField
    }()
    
    lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pay", for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(pay), for: .touchUpInside)
        return button
    }()
    
    var stackView = UIStackView()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 0.2)
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addCardTextField()
        addSheet()
        hyperModel.preparePaymentSheet()
    }
    
    @objc func openPaymentSheet(_ sender: Any) {
        hyperModel.paymentSheet?.present(from: self, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .completed:
                    self.statusLabel.text = "Payment complete"
                case .failed(let error):
                    self.statusLabel.text =  "Payment failed: \(error.localizedDescription)"
                case .canceled:
                    self.statusLabel.text = "Payment canceled."
                }
            }
        })
    }
}

extension PaymentViewController {
    
    func addCardTextField() {
        
        hyperLabel.text = "Hyper Element"
        
        stackView = UIStackView(arrangedSubviews: [hyperLabel, hyperCardTextField, payButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
    }
    
    func addSheet()
    {
        paymentSheetButton.setTitle("Hyper Payment Sheet", for: .normal)
        paymentSheetButton.setTitleColor(.white, for: .normal)
        paymentSheetButton.contentEdgeInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        paymentSheetButton.layer.cornerRadius = 10
        paymentSheetButton.backgroundColor = .systemBlue
        paymentSheetButton.addTarget(self, action: #selector(openPaymentSheet(_:)), for: .touchUpInside)
        view.addSubview(paymentSheetButton)
        paymentSheetButton.translatesAutoresizingMaskIntoConstraints = false
        paymentSheetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        paymentSheetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
        paymentSheetButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40).isActive = true
        
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 3
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        statusLabel.topAnchor.constraint(equalTo: paymentSheetButton.bottomAnchor, constant: 50).isActive = true
        
    }
    
    @objc
    func pay() {
        guard let paymentIntentClientSecret = hyperModel.paymentIntentClientSecret else {
            return
        }
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        paymentIntentParams.paymentMethodParams = hyperCardTextField.paymentMethodParams
        
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(paymentIntentParams, with: self)
        { (status, paymentIntent, error) in
            switch (status) {
            case .failed:
                break
            case .canceled:
                break
            case .succeeded:
                break
            @unknown default:
                fatalError()
                break
            }
        }
    }
}
