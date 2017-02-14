//
//  AgreementViewController.swift
//  AgreementKit
//
//  Created by Jake Young on 12/28/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import UIKit
import MessageUI

public typealias Callback = () -> ()


/**
 
 Delegate for managing when consent is shown by the Agreement View Controller.
 
 Useful for logging additional activity or dismissing the controller.
 
 */
public protocol AgreementViewControllerDelegate {
    
    /// The first primary consent agreement has been agreed to to by the user.
    ///
    /// - Parameter controller: the view controller presented showing the agreement.
    func didProvideConsent(using controller: AgreementViewController)
    
    /// The first primary consent agreement has been declined by the user.
    ///
    /// - Parameter controller: the view controller presented showing the agreement.
    func didDeclineConsent(using controller: AgreementViewController)
    
    /// The secondary consent controller has been agreed to.
    func didProvideAffirmativeConsent()
    
    /// The secondary consent controller has been declined.
    func didDeclineAffirmativeConsent()
    
}


/// A generic protocol for enforcing `continue` and `cancel` workflows with agreements.
public protocol AgreementViewManager: AgreementProvider {
    var continueCallback: Callback? { get set }
    var cancelCallback: Callback? { get set }
}


/**
 
 This view controller is shown modally and can be created with a custom agreement.
 
 This approach mimics the iOS software update workflow:
 
 1. The iOS Terms and Conditions view first pops up showing the long form agreement.
 2. An alert is used for secondary confirmation.
 
 # Conform to `AgreementProvider`
 
 `AgreementViewController` will change it's style based on the agreement provided in your presenting view controller.
 
 If you would like to present an `AgreementViewController` from any view controller easily, have your view controller conform to the `AgreementProvider` protocol.
 
 */
public class AgreementViewController: UIViewController, AgreementViewManager {
    
    public var delegate: AgreementViewControllerDelegate?
    
    convenience init(agreementProvider provider: AgreementProvider, continueCallback: Callback?, cancelCallback: Callback?) {
        self.init(
            agreement: provider.agreementToPresent,
            secondaryAgreement: provider.secondaryAgreementToPresent,
            continueCallback: continueCallback,
            cancelCallback: cancelCallback
        )
        
        if let delegate = provider as? AgreementViewControllerDelegate {
            self.delegate = delegate
        }
    }
    
    /// Designated initializer using an Agreement.
    ///
    /// - Parameters:
    ///   - agreement: the primary agreement, shown as either `alert`, `textbox`, or `multipart`.
    ///   - affirmativeAgreement: an optional secondary agreement that is shown when the user agrees to the primary agreement.
    ///   - continueCallback: the action to perform when all agreements are agreed to.
    ///   - cancelCallback: the action to perform when the primary agreement is declined.
    public init(agreement: Agreement, secondaryAgreement: Agreement? = nil, continueCallback: Callback?, cancelCallback: Callback?) {
        
        let bundle = Bundle(for: AgreementViewController.self)
        super.init(nibName: "AgreementViewController", bundle: bundle)
        
        self.agreementToPresent = agreement
        self.secondaryAgreementToPresent = secondaryAgreement
        self.continueCallback = continueCallback
        self.cancelCallback = cancelCallback
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// the primary agreement, shown as either `alert`, `textbox`, or `multipart`.
    public var agreementToPresent: Agreement!
    
    /// the optional secondary agreement that is shown when the user agrees to the primary agreement.
    public var secondaryAgreementToPresent: Agreement?
    
    /// the action to perform when all agreements are agreed to.
    public var continueCallback: Callback?
    
    /// the action to perform when the primary agreement is declined
    public var cancelCallback: Callback?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = agreementToPresent.title
        
        setupNavigation()
    }
    
    
    /// Shows the affirmative Alert and continues or cancels depending on the user's choice.
    ///
    /// - Parameters:
    ///   - continueCallback: the action to perform when the affirmative agreement is agreed to.
    ///   - cancelCallback: the action to perform when the primary agreement is declined.
    func askForAffirmativeConsent(andContinue continueCallback: @escaping Callback, orCancel cancelCallback: @escaping Callback) {
        
        let alert = UIAlertController(title: secondaryAgreementToPresent?.title, message: secondaryAgreementToPresent?.message, preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: secondaryAgreementToPresent?.continueLabel, style: .default)  { action in
            continueCallback()
            self.delegate?.didProvideAffirmativeConsent()
        }
        
        let cancel = UIAlertAction(title: secondaryAgreementToPresent?.cancelLabel, style: .cancel) { action in
            self.delegate?.didDeclineAffirmativeConsent()
            return
        }
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension AgreementViewController {
    
    
    /// Dismisses the view controller and executes the continue callback.
    func dismissAndContinue() {
        dismiss(animated: true) {
            self.continueCallback?()
            self.delegate?.didProvideConsent(using: self)
        }
    }
    
    /// The user has accepted the agreement.
    @objc func continueButtonTapped() {
        
        if agreementToPresent.requiresAffirmativeConsent {
            
            askForAffirmativeConsent(andContinue: { 
                self.dismissAndContinue()
            }, orCancel: { 
                return
            })
            
        } else {
            self.dismissAndContinue()
        }
    
    }
    
    
    /// The user has declined the primary agreement.
    @objc func cancelButtonTapped() {
        dismiss(animated: true) {
            self.cancelCallback?()
            self.delegate?.didDeclineConsent(using: self)
        }
    }
    
    fileprivate var continueButton: UIBarButtonItem {
        let action = #selector(TextboxViewController.continueButtonTapped)
        return UIBarButtonItem(title: agreementToPresent.continueLabel, style: .done, target: self, action: action)
    }
    
    fileprivate var cancelButton: UIBarButtonItem {
        let action = #selector(TextboxViewController.cancelButtonTapped)
        return UIBarButtonItem(title: agreementToPresent.cancelLabel, style: .plain, target: self, action: action)
    }
    
    fileprivate var flexibleBarButtonSpace: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    fileprivate func setupNavigation() {
        switch agreementToPresent.navigationPosition {
        case .top:
            self.navigationItem.leftBarButtonItem = cancelButton
            self.navigationItem.rightBarButtonItem = continueButton
        case .bottom:
            self.navigationController?.setToolbarHidden(false, animated: false)
            self.setToolbarItems([cancelButton, flexibleBarButtonSpace, continueButton], animated: false)
        }
    }
}

extension AgreementViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            controller.dismiss(animated: true, completion: nil)
        default:
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
