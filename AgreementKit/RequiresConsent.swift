//
//  RequiresConsent.swift
//  AgreementKit
//
//  Created by Jake Young on 12/28/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

protocol ConsentRequiredDelegate {
    var consentRequired: Bool { get }
    func agreedToConsentForm()
    func disagreedToConsentForm()
}
