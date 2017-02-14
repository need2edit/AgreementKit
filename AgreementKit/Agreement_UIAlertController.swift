//
//  Agreement_UIAlertController_.swift
//  AgreementKit
//
//  Created by Jake Young on 1/2/17.
//  Copyright © 2017 Jake Young. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    convenience init(with agreement: Agreement, andContinue continueCallback: @escaping Callback, orCancel cancelCallback: @escaping Callback) {
    
        self.init(title: agreement.title, message: agreement.message, preferredStyle: .alert)
    
        let agree = UIAlertAction(title: agreement.continueLabel, style: .default, handler: { action in
            continueCallback()
        })
    
        let cancel = UIAlertAction(title: agreement.cancelLabel, style: .cancel, handler: { action in
            cancelCallback()
        })
    
        self.addAction(agree)
        self.addAction(cancel)
    }
    
    convenience init(_ agreementProvider: AgreementProvider, presenter: UIViewController, continueCallback: @escaping Callback, orCancel cancelCallback: @escaping Callback) {
        
        guard let agreement = agreementProvider.agreementToPresent else { fatalError("No agreement on provided for this alert") }
        
        
        self.init(with: agreement, andContinue: {
        
            guard let secondaryAgreement = agreementProvider.secondaryAgreementToPresent, agreement.requiresAffirmativeConsent else {
                return continueCallback()
            }
            
            let secondaryAlert = UIAlertController(with: secondaryAgreement, andContinue: continueCallback, orCancel: {
                return
            })
            
            DispatchQueue.main.async { presenter.present(secondaryAlert, animated: true, completion: nil) }
            
        }, orCancel: {
            return
        })
        
    }
    
    
}
