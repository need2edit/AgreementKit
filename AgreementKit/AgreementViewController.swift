//
//  AgreementViewController.swift
//  AgreementKit
//
//  Created by Jake Young on 12/28/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import UIKit
import MessageUI

protocol AgreementViewManager {
    
    var agreement: Agreement! { get set }
    var continueCallback: Callback? { get set }
    var cancelCallback: Callback? { get set }
}

public class AgreementViewController: UIViewController, AgreementViewManager {
    
    var agreement: Agreement!
    var continueCallback: Callback?
    var cancelCallback: Callback?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = agreement.title
        
        setupNavigation()
    }
    
    func askForAffirmativeConsent(andContinue continueCallback: @escaping Callback, orCancel cancelCallback: @escaping Callback) {
        
        let alert = UIAlertController(title: "Affirmative Consent", message: "Are you sure you're sure?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default)  { action in
            continueCallback()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            return
        }
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
}

extension AgreementViewController {
    
    func dismissAndContinue() {
        dismiss(animated: true) {
            self.continueCallback?()
        }
    }
    
    @objc func continueButtonTapped() {
        
        if agreement.requiresAffirmativeConsent {
            
            askForAffirmativeConsent(andContinue: { 
                self.dismissAndContinue()
            }, orCancel: { 
                return
            })
            
        } else {
            self.dismissAndContinue()
        }
    
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true) {
            self.cancelCallback?()
        }
    }
    
    fileprivate var continueButton: UIBarButtonItem {
        let action = #selector(TextboxViewController.continueButtonTapped)
        return UIBarButtonItem(title: "Agree", style: .done, target: self, action: action)
    }
    
    fileprivate var cancelButton: UIBarButtonItem {
        let action = #selector(TextboxViewController.cancelButtonTapped)
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: action)
    }
    
    fileprivate var flexibleBarButtonSpace: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    fileprivate func setupNavigation() {
        switch agreement.navigationPosition {
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
