//
//  Agreement.swift
//  AgreementKit
//
//  Created by Jake Young on 12/28/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import UIKit

public struct Agreement {

    // MARK: Properties
    let style: Style
    let title: String
    let message: String?
    
    let sections: [Section]
    
    let continueLabel: String
    let cancelLabel: String
    
}


// MARK: - Enumerations
extension Agreement {
    
    /// Positions buttons in the navigation item or in the toolbar
    ///
    /// - top: places controls in the navigation bar
    /// - bottom: places controls in the toolbar
    public enum NavigationPosition {
        case top
        case bottom
    }
    
    /// Agreement Sections are have 3 distinct types:
    ///
    /// - text: a block of text with a title and optional text body
    /// - callToAction: describes an action the user can interact with
    /// - link: a URL with a label
    public enum Section {
        case text(String, String?)
        case link(String, URL?)
        case callToAction(String)
        
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
    
}


// MARK: - Initialization
extension Agreement {
    
    /// Default initalizer with a title, message, and labels for buttons.
    ///
    /// - Parameters:
    ///   - title: The title of the agreement. This appears in the navigatin title of alert title.
    ///   - message: The body text of the agreement. This appears in the text area of the form, or as the message in an alert.
    ///   - style: The overall style of the agreement. `Alert`, `Textbox`, `Multipart` are available.
    ///   - continueLabel: label for the agree button
    ///   - cancelLabel: label for the cancel button
    public init(title: String, message: String?, style: Style = .alert, continueLabel: String = "Agree", cancelLabel: String = "Cancel") {
        self.style = style
        self.title = title
        self.message = message
        self.continueLabel = continueLabel
        self.cancelLabel = cancelLabel
        self.sections = [.text(title, message)]
    }
    
    
    /// Initalizer with a title, labels for buttons, and multiple sections.
    ///
    /// - Parameters:
    ///   - title: the title for the agreement
    ///   - sections: the text blocks, links, and calls to action for the agreement
    ///   - style: the overall style for the agreement
    ///   - continueLabel: the label for the agree button
    ///   - cancelLabel: label for the cancel button
    public init(title: String, sections: [Section], style: Style = .alert, continueLabel: String = "Agree", cancelLabel: String = "Cancel") {
        self.style = style
        self.title = title
        self.message = nil
        self.continueLabel = continueLabel
        self.cancelLabel = cancelLabel
        self.sections = sections
    }
}

extension Agreement {
    
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
}

