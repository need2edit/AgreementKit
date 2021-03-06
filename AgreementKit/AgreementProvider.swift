//
//  AgreementProvider.swift
//  AgreementKit
//
//  Created by Jake Young on 12/31/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation
import UIKit


/// Objects conforming to `AffirmativeConsentProvider` provide an optional agreement which manifests as an additional level of consent. For example, when a terms and conditions screen appears, you may want the user to consent a second time.
public protocol AffirmativeConsentProvider {
    
    /// The agreement for the secondary notice that will appear. This appears as an additional alert on top of the first agreement.
    var secondaryAgreementToPresent: Agreement? { get }
}

/// Objects conforming to `AgreementProvider` provide two agreements:
///
/// * agreementToPresent (required) - The primary agreement the user must consent to.
/// * secondaryAgreementToPresent (optional) - An optional secondary agreement for confirming consent.
///
/// - seealso: `AffirmativeConsentProvider`
public protocol AgreementProvider: AffirmativeConsentProvider {
    
    /// the primary agreement to present, shown as either `alert`, `textbox`, or `multipart`.
    var agreementToPresent: Agreement! { get }
}

extension AffirmativeConsentProvider {
    
    /// wether or not the secondary alert should be shown
    var consentRequired: Bool { return secondaryAgreementToPresent != nil}
}

extension AgreementProvider {
    
    fileprivate var preferredAgreementStyle: Agreement.Style {
        return agreementToPresent.style
    }
    
    fileprivate var agreementTitle: String {
        return agreementToPresent.title
    }
    
    fileprivate var agreementDescription: String? {
        return agreementToPresent.message
    }
}

extension AgreementProvider where Self: UIViewController {
    
    /// Convience method for presenting alerts from more complicated view hierarchies.
    ///
    /// - Parameters:
    ///   - viewControllerToPresent: the view controller to present
    ///   - viewController: the view controller to present from
    func present(_ viewControllerToPresent: UIViewController, from context: UIViewController? = nil) {
        
        let presenter = context ?? self
        presenter.present(viewControllerToPresent, animated: true, completion: nil)
        
    }
    
    /// Creates an alert with 2 actions
    ///
    /// - Parameters:
    ///   - continueCallback: action to perform is the user accepts the agreement
    ///   - cancelCallback: action to perform is the user does not accept the agreement
    /// - Returns: UIAlertController with 2 actions, one to continue, one to cancel
    
    public func requireConsent(andContinue continueCallback: @escaping () -> ()) {
        requireConsent(andContinue: continueCallback, orCancel: {
            return
        })
    }
    
    /// Presents a modal view controller before proceeding.
    ///
    /// - Parameters:
    ///   - continueCallback: code that executes when the user agrees
    ///   - cancelCallback: code that executes when the user declines
    public func requireConsent(andContinue continueCallback: @escaping () -> (), orCancel cancelCallback: @escaping () -> ()) {
        
        switch preferredAgreementStyle {
            
        case .alert:
            
            let alert = UIAlertController(self, presenter: self, continueCallback: continueCallback, orCancel: cancelCallback)
            DispatchQueue.main.async { self.present(alert) }
            
        case .multipart:
            
            let multipartVC = MultiPartAgreementViewController(agreementProvider: self, continueCallback: continueCallback, cancelCallback: cancelCallback)
            
            let nav = UINavigationController(rootViewController: multipartVC)
            nav.modalPresentationStyle = .formSheet
            DispatchQueue.main.async { self.present(nav) }
            
        case .textbox:
            
            let textboxVC = TextboxViewController(agreementProvider: self, continueCallback: continueCallback, cancelCallback: cancelCallback)
            
            let nav = UINavigationController(rootViewController: textboxVC)
            nav.modalPresentationStyle = .formSheet
            DispatchQueue.main.async { self.present(nav) }
        }
        
        
    }
    
}
