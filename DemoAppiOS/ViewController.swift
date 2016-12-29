//
//  ViewController.swift
//  DemoAppiOS
//
//  Created by Jake Young on 12/28/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import UIKit
import AgreementKit

class ViewController: UIViewController, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case Agreed
        case Disagreed
    }

    @IBAction func demoConsentForm(_ sender: Any) {
        
        askForConsent(andContinue: {
            // do something after agreement
            DispatchQueue.main.async { self.performSegue(segueIdentifier: .Agreed) }
            
        }) {
            // cancel
            return
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performDemoButton.layer.cornerRadius = 6.0
        performDemoButton.backgroundColor = view.tintColor
    }

    @IBOutlet weak var performDemoButton: UIButton!
    @IBOutlet weak var affirmativeConsentControl: UISwitch!
    
    @IBOutlet weak var navigationPositionSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var agreementStyleSegmentedControl: UISegmentedControl!
    
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

extension ViewController: AgreementManager {
    
    func agreementToPresent() -> Agreement {
        
        let body = "This is a sample agreement."
        
        return Agreement(title: "Terms & Conditions", message: body, style: agreementStyle)
    }
    
}

