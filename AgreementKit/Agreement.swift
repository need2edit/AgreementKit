//
//  Agreement.swift
//  AgreementKit
//
//  Created by Jake Young on 12/28/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import UIKit

public protocol AgreementDelegate {
    
    func didProvideConsent()
    func didDeclineConsent()
    
    func didProvideAffirmativeConsent()
    func didDeclineAffirmativeConsent()
    
}

public struct Agreement {
    
    /// Controls the type of agreement UI that will appear for the user. This falls into one of three categories:
    ///
    /// - alert: Simple alert, designed to be 1-2 lines
    /// - textbox: A full page form with body text in a textview
    /// - multipart: A form with sections. Supports text, links, and calls to action.
    public enum Style {
        case alert
        case textbox(affirmativeConsent: Bool, navigationPosition: NavigationPosition)
        case multipart(affirmativeConsent: Bool, navigationPosition: NavigationPosition)
    }
    
    /// Positions buttons in the navigation item or in the toolbar
    ///
    /// - top: places controls in the navigation bar
    /// - bottom: places controls in the toolbar
    public enum NavigationPosition {
        case top
        case bottom
    }
    
    let style: Style
    let title: String
    let message: String?
    
    var requiresAffirmativeConsent: Bool {
        switch style {
        case .alert: return false
        case .multipart(affirmativeConsent: let affirmative, navigationPosition: _), .textbox(affirmativeConsent: let affirmative, navigationPosition: _):
            return affirmative
        }
    }
    
    var navigationPosition: NavigationPosition {
        switch style {
        case .alert: return .bottom
        case .multipart(affirmativeConsent: _, navigationPosition: let position), .textbox(affirmativeConsent: _, navigationPosition: let position):
            return position
        }
    }
    
    /// Default initalizer with Strings.
    ///
    /// - Parameters:
    ///   - title: The title of the agreement. This appears in the navigatin title of alert title.
    ///   - message: The body text of the agreement. This appears in the text area of the form, or as the message in an alert.
    ///   - style: The overall style of the agreement. `Alert`, `Textbox`, `Multipart` are available.
    public init(title: String, message: String?, style: Style = .alert) {
        self.style = style
        self.title = title
        self.message = message
    }
    
}

public protocol AgreementProvider {
    /// Provides the agreeement
    var agreementToPresent: Agreement { get }
}

public protocol AffirmativeConsentProvider: AgreementProvider {
    
    /// The agreement for the secondary notice that will appear. This appears as an additional alert on top of the first agreement.
    var affirmativeConsentAgreement: Agreement? { get }
}

extension AffirmativeConsentProvider {
    var consentRequired: Bool { return agreementToPresent != nil}
}

extension AgreementProvider {
    
    func preferredAgreementStyle() -> Agreement.Style {
        return agreementToPresent.style
    }
    
    func titleForAgreement() -> String {
        return agreementToPresent.title
    }
    
    func descriptionForAgrement() -> String? {
        return agreementToPresent.message
    }
}

extension AgreementProvider where Self: UIViewController {
    
    func presentAgreement(agreementViewController: UIViewController, from viewController: UIViewController? = nil) {
        
        let presenter = viewController ?? self
        presenter.present(agreementViewController, animated: true, completion: nil)
        
    }
    
    /// Creates an alert with 2 actions
    ///
    /// - Parameters:
    ///   - continueCallback: action to perform is the user accepts the agreement
    ///   - cancelCallback: action to perform is the user does not accept the agreement
    /// - Returns: UIAlertController with 2 actions, one to continue, one to cancel
    fileprivate func alertViewController(andContinue continueCallback: @escaping () -> (), orCancel cancelCallback: @escaping () -> ()) -> UIAlertController {
        
        let alert = UIAlertController(title: titleForAgreement(), message: descriptionForAgrement(), preferredStyle: .alert)
        
        let agree = UIAlertAction(title: "Agree", style: .default, handler: { action in
            continueCallback()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            cancelCallback()
        })
        
        alert.addAction(agree)
        alert.addAction(cancel)
        
        return alert
    }
    
    public func askForConsent(andContinue continueCallback: @escaping () -> (), orCancel cancelCallback: @escaping () -> ()) {
        
        let style = preferredAgreementStyle()
        
        switch style {
            
        case .alert:
            
            let alert = alertViewController(andContinue: continueCallback, orCancel: cancelCallback)
            
            DispatchQueue.main.async {
                self.presentAgreement(agreementViewController: alert)
            }
            
        case .multipart:
            
            let bundle = Bundle(for: MultiPartAgreementViewController.self)
            let multipartVC = MultiPartAgreementViewController(nibName: "MultiPartAgreementViewController", bundle: bundle)
            multipartVC.cancelCallback = cancelCallback
            multipartVC.continueCallback = continueCallback
            multipartVC.agreement = agreementToPresent
            
            let nav = UINavigationController(rootViewController: multipartVC)
            nav.modalPresentationStyle = .formSheet
            presentAgreement(agreementViewController: nav)
            
        case .textbox:
            
            let bundle = Bundle(for: TextboxViewController.self)
            let textboxVC = TextboxViewController(nibName: "TextboxViewController", bundle: bundle)
            textboxVC.cancelCallback = cancelCallback
            textboxVC.continueCallback = continueCallback
            textboxVC.agreement = agreementToPresent
            
            let nav = UINavigationController(rootViewController: textboxVC)
            nav.modalPresentationStyle = .formSheet
            presentAgreement(agreementViewController: nav)
        }

        
    }
    
}

