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

public protocol AgreementViewControllerDelegate {
    
    func didProvideConsent(using controller: AgreementViewController)
    func didDeclineConsent(using controller: AgreementViewController)
    
    func didProvideAffirmativeConsent()
    func didDeclineAffirmativeConsent()
    
}

public protocol AgreementViewManager: AgreementProvider {
    var continueCallback: Callback? { get set }
    var cancelCallback: Callback? { get set }
}

public class AgreementViewController: UIViewController, AgreementViewManager {
    
    public var delegate: AgreementViewControllerDelegate?
    
    convenience init(agreementProvider provider: AgreementProvider, continueCallback: Callback?, cancelCallback: Callback?) {
        self.init(
            agreement: provider.agreementToPresent,
            affirmativeAgreement: provider.affirmativeConsentAgreement,
            continueCallback: continueCallback,
            cancelCallback: cancelCallback
        )
    }
    
    public init(agreement: Agreement, affirmativeAgreement: Agreement? = nil, continueCallback: Callback?, cancelCallback: Callback?) {
        
        let bundle = Bundle(for: AgreementViewController.self)
        super.init(nibName: "AgreementViewController", bundle: bundle)
        
        self.agreementToPresent = agreement
        self.affirmativeConsentAgreement = affirmativeAgreement
        self.continueCallback = continueCallback
        self.cancelCallback = cancelCallback
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var agreementToPresent: Agreement!
    public var affirmativeConsentAgreement: Agreement?
    
    public var continueCallback: Callback?
    public var cancelCallback: Callback?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = agreementToPresent.title
        
        setupNavigation()
    }
    
    func askForAffirmativeConsent(andContinue continueCallback: @escaping Callback, orCancel cancelCallback: @escaping Callback) {
        
        let alert = UIAlertController(title: affirmativeConsentAgreement?.title, message: affirmativeConsentAgreement?.message, preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: affirmativeConsentAgreement?.continueLabel, style: .default)  { action in
            continueCallback()
            self.delegate?.didProvideAffirmativeConsent()
        }
        
        let cancel = UIAlertAction(title: affirmativeConsentAgreement?.cancelLabel, style: .cancel) { action in
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
