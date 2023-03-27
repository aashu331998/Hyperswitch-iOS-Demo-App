import UIKit
import SwiftUI
import hyperswitch

class ViewController: UIViewController {
    
    @ObservedObject var hyperModel = HyperBackendModel()
    var paymentSheet: HyperPaymentSheet?
    var paymentResult: HyperPaymentSheetResult?
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["SwiftUI", "UIKit"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let swiftUIButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("UIKIT Button", for: .normal)
        button.addTarget(self, action: #selector(swiftUIButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.bottomView.paymentSheetButton.isEnabled = false
//        self.bottomView.paymentSheetButton.setTitle("Loading...", for: .normal)
        setupViews()
        hyperModel.preparePaymentSheet()
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // Show SwiftUI button
            let swiftUIHostingController = UIHostingController(rootView: SwiftUIButtonView())
            addChild(swiftUIHostingController)
            view.addSubview(swiftUIHostingController.view)
            swiftUIHostingController.didMove(toParent: self)
            swiftUIHostingController.view.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                swiftUIHostingController.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 100),
                swiftUIHostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                swiftUIHostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                swiftUIHostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            swiftUIButton.removeFromSuperview()
            
        case 1:
            // Show UIKit button
            view.addSubview(swiftUIButton)
            
            NSLayoutConstraint.activate([
                swiftUIButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
                swiftUIButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            
            for child in children {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
            }
            
        default:
            break
        }
    }
    
    @objc private func swiftUIButtonTapped(_ sender: UIButton) {
//            self.bottomView.paymentSheetButton.isEnabled = true
//            self.button.setTitle("Checkout", for: .normal)
            self.hyperModel.paymentSheet?.present(from: self, completion: { result in
                DispatchQueue.main.async {
                        switch result {
                        case .completed:
                            print("Payment complete")
                        case .failed(let error):
                            print("Payment failed: \(error.localizedDescription)")
                        case .canceled:
                            print("Payment canceled.")
                        }
                }
            })
        print("SwiftUI button tapped!")
    }
    
    private func setupViews() {
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        segmentedControlValueChanged(segmentedControl)
    }
}
