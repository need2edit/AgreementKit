//
//  TextboxViewController.swift
//  AgreementKit
//
//  Created by Jake Young on 12/28/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import UIKit

extension Selector { }

public class TextboxViewController: AgreementViewController {
    
    lazy var textView: UITextView = {
        
        let tv = UITextView(frame: .zero)
        return tv
        
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = agreementToPresent.title
        
        // Have this be a smaller form style
        self.modalPresentationStyle = .formSheet
        self.navigationController?.modalPresentationStyle = .formSheet
        
        // Setup text view
        view.addSubview(textView)
        
        view.addConstraintsWithFormat("V:|-[v0]-|", views: textView)
        view.addConstraintsWithFormat("H:|-[v0]-|", views: textView)
        
        if let message = agreementToPresent.message {
            
            textView.attributedText = NSAttributedString(string: message, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0), NSForegroundColorAttributeName: UIColor.black])
        }
        
        view.backgroundColor = .white
        
    }

}
