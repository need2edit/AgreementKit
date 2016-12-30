//
//  ViewController.swift
//  DemoAppiOS
//
//  Created by Jake Young on 12/28/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import UIKit
import AgreementKit

class ViewController: UIViewController {
    
    // MARK: - Demo Controls
    @IBOutlet weak var performDemoButton: UIButton!
    @IBOutlet weak var affirmativeConsentControl: UISwitch!
    @IBOutlet weak var navigationPositionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var agreementStyleSegmentedControl: UISegmentedControl!
    
    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "AgreementKit"
        performDemoButton.layer.cornerRadius = 6.0
        performDemoButton.backgroundColor = view.tintColor
    }

}

// MARK: - Determining Demo Options from Selected
extension ViewController {
    
    var affirmativeConsentRequired: Bool {
        return affirmativeConsentControl.isOn
    }
    
    var navigationPosition: Agreement.NavigationPosition {
        return (navigationPositionSegmentedControl.selectedSegmentIndex == 0) ? .bottom : .top
    }
    
    var agreementStyle: Agreement.Style {
        switch agreementStyleSegmentedControl.selectedSegmentIndex {
        case 0:
            return .alert
        case 1:
            return .textbox(affirmativeConsent: affirmativeConsentRequired, navigationPosition: navigationPosition)
        case 2:
            return .multipart(affirmativeConsent: affirmativeConsentRequired, navigationPosition: navigationPosition)
        default: return .alert
        }
    }
    
}


// MARK: - SegueHandlerType
extension ViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        case Agreed
        case Disagreed
    }
    
    // MARK: - Run Demo
    @IBAction func demoConsentForm(_ sender: Any) {
        
        requireConsent(before: {
            // proceeding
            DispatchQueue.main.async { self.performSegue(segueIdentifier: .Agreed) }
        }) {
            // cancelling
            return
        }
        
    }
    
}

extension ViewController: AgreementProvider {
    
    fileprivate var bodyText: String {
        switch agreementStyle {
        case .alert:
            return "This is a primary agreement. The alert style usually only has 1-3 lines of body text."
        case .multipart:
            return "This is a primary agreement. The multipart style uses multiple sections with different styles."
        case .textbox:
            return "This is a primary agreement. The text box style is designed for a few paragraphs of text. \n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus non pharetra ipsum, quis semper neque. Cras ac ante sapien. Etiam non felis fermentum, fermentum erat in, volutpat diam. Cras a metus maximus, mattis erat ac, eleifend velit. Maecenas nec lacus sodales, imperdiet quam sit amet, elementum est. Aliquam ipsum ligula, pretium sollicitudin justo ut, vestibulum vehicula tellus. Vivamus feugiat mauris nec leo pharetra ullamcorper. \n\nQuisque nulla lorem, eleifend id nisl eget, ultrices consequat dolor. Phasellus purus erat, semper eget neque ut, sodales congue diam. Nullam accumsan quam sit amet mauris tincidunt suscipit. Nullam pellentesque egestas nisi vel cursus. Integer massa ex, posuere vitae sollicitudin sit amet, bibendum sit amet mi. Vivamus ut fermentum nunc, quis venenatis mauris. Duis non sagittis dolor. In bibendum feugiat ex sit amet luctus. Vivamus imperdiet egestas mauris, sit amet eleifend sem. Nullam elementum lacus eleifend dapibus maximus. Integer a mi nisi. Integer non massa dictum lectus fringilla malesuada. Cras pellentesque vitae nisl vel tincidunt. Pellentesque a tempus libero, non scelerisque turpis. Nulla sit amet felis et nisl accumsan convallis sed rhoncus dolor. Nam diam velit, vehicula at feugiat nec, ullamcorper vel diam."
        }
    }
    
    var agreementToPresent: Agreement! {
        return Agreement(title: "Terms & Conditions", message: bodyText, style: agreementStyle, continueLabel: "I'm Sure", cancelLabel: "Nope!")
    }
    
    var affirmativeConsentAgreement: Agreement? {
        let body = "This is called \"Affirmative Consent\", or a secondary agreement that you're requiring because you really want people to be sure."
        return Agreement(title: "Are you sure you're sure?", message: body, style: .alert, continueLabel: "Continue", cancelLabel: "Nope!")
    }
    
}

