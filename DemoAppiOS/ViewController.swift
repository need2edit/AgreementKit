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
            return .textbox(navigationPosition: navigationPosition)
        case 2:
            return .multipart(navigationPosition: navigationPosition)
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
    
        requireConsent {
            DispatchQueue.main.async { self.performSegue(segueIdentifier: .Agreed) }
        }
        
    }
    
}

extension ViewController: AgreementProvider {
    
    var agreementToPresent: Agreement! {
        switch agreementStyle {
        case .alert:
            return Agreement.Example.alert(affirmativeConsent: affirmativeConsentRequired)
        case .multipart:
            return Agreement.Example.multipart(affirmativeConsent: affirmativeConsentRequired, navigationPosition: navigationPosition)
        case .textbox:
            return Agreement.Example.textbox(affirmativeConsent: affirmativeConsentRequired, navigationPosition: navigationPosition)
        }
    }
    
    var secondaryAgreementToPresent: Agreement? {
        
        let body = "This is called \"Affirmative Consent\", or a secondary agreement that you're requiring because you really want people to be sure."
        
        return Agreement(title: "Are you sure you're sure?", message: body, style: .alert, requiresAffirmativeConsent: affirmativeConsentRequired, continueLabel: "Continue", cancelLabel: "Nope!")
    }
    
}

