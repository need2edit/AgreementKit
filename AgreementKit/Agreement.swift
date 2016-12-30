//
//  Agreement.swift
//  AgreementKit
//
//  Created by Jake Young on 12/28/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import UIKit

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
    
    public enum Section {
        case text(String, String?)
        case callToAction(String)
        case link(String, URL?)
        
        public var attributedText: NSAttributedString {
            switch self {
            case .text(let headline, let bodyText):
                let rowText = NSMutableAttributedString(string: headline.uppercased(), attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
                
                if let bodyText = bodyText, !bodyText.isEmpty {
                    
                    let formattedBodyText = NSMutableAttributedString(string: bodyText, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14)])
                    
                    rowText.append(NSAttributedString(string: "\n"))
                    
                    rowText.append(formattedBodyText)
                    
                }
                return rowText
            case .callToAction(let description):
                return NSMutableAttributedString(string: description, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)])
            case .link(let description, _):
                return NSMutableAttributedString(string: description, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
            }
        }
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
    
    let sections: [Section]
    
    let continueLabel: String
    let cancelLabel: String
    
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
    public init(title: String, message: String?, style: Style = .alert, continueLabel: String = "Agree", cancelLabel: String = "Cancel") {
        self.style = style
        self.title = title
        self.message = message
        self.continueLabel = continueLabel
        self.cancelLabel = cancelLabel
        self.sections = [.text(title, message)]
    }
    
    public init(title: String, sections: [Section], style: Style = .alert, continueLabel: String = "Agree", cancelLabel: String = "Cancel") {
        self.style = style
        self.title = title
        self.message = nil
        self.continueLabel = continueLabel
        self.cancelLabel = cancelLabel
        self.sections = sections
    }
    
}

public protocol AffirmativeConsentProvider {
    
    /// The agreement for the secondary notice that will appear. This appears as an additional alert on top of the first agreement.
    var affirmativeConsentAgreement: Agreement? { get }
}

public protocol AgreementProvider: AffirmativeConsentProvider {
    /// Provides the agreeement
    var agreementToPresent: Agreement! { get }
}

extension AffirmativeConsentProvider {
    var consentRequired: Bool { return affirmativeConsentAgreement != nil}
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
    fileprivate func alertViewController(andContinue continueCallback: @escaping () -> (), orCancel cancelCallback: @escaping () -> ()) -> UIAlertController {
        
        let alert = UIAlertController(title: agreementTitle, message: agreementDescription, preferredStyle: .alert)
        
        let agree = UIAlertAction(title: agreementToPresent.continueLabel, style: .default, handler: { action in
            continueCallback()
        })
        
        let cancel = UIAlertAction(title: agreementToPresent.cancelLabel, style: .cancel, handler: { action in
            cancelCallback()
        })
        
        alert.addAction(agree)
        alert.addAction(cancel)
        
        return alert
    }
    
    
    /// Presents a modal view controller before proceeding.
    ///
    /// - Parameters:
    ///   - continueCallback: code that executes when the user agrees
    ///   - cancelCallback: code that executes when the user declines
    public func requireConsent(before continueCallback: @escaping () -> (), orCancel cancelCallback: @escaping () -> ()) {
        
        switch preferredAgreementStyle {
            
        case .alert:
            
            let alert = alertViewController(andContinue: continueCallback, orCancel: cancelCallback)
            
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

