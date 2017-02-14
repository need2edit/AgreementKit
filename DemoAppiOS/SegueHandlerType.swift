//
//  SegueHandlerType.swift
//  Moody
//
//  Created by Florian on 12/06/15.
//  Copyright © 2015 objc.io. All rights reserved.
//

import UIKit


/// Allows enums to be used instead of strings for safer segue management.
///
/// Example:
/// ```
/// enum SegueIdentifier: String {
///    case showDetails
///    case showLogin
/// }
///
/// // usage on UIViewController
/// vc.performSegue(segueIdentifier: .showDetails)
///
public protocol SegueHandlerType {
     associatedtype SegueIdentifier: RawRepresentable
}


extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {

    public func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier)
        else { fatalError("Unknown segue: \(segue))") }
        return segueIdentifier
    }

    
    /// Overloads standard perform performSegue(:) with safer SegueIdentifier
    ///
    /// - Parameter segueIdentifier: the segue you want to perform
    public func performSegue(segueIdentifier: SegueIdentifier) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: nil)
    }

}

