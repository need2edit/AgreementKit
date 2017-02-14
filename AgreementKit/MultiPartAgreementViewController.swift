//
//  MultiPartAgreementViewController.swift
//  AgreementKit
//
//  Created by Jake Young on 12/28/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices


/// Shows the agreement in styled sections.
public class MultiPartAgreementViewController: AgreementViewController {

    enum RowStyle {
        case inline
        case centered
        case text
    }
    
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        
        tv.estimatedRowHeight = 44.0
        tv.rowHeight = UITableViewAutomaticDimension
        
        tv.dataSource = self
        tv.delegate = self
       return tv
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCell(UITableViewCell.self)
        tableView.tableFooterView = UITableViewHeaderFooterView()
        
        view.addSubview(tableView)
        view.addConstraintsWithFormat("V:|[v0]|", views: tableView)
        view.addConstraintsWithFormat("H:|[v0]|", views: tableView)
        
    }

}

extension MultiPartAgreementViewController.RowStyle {
    func update(cell: UITableViewCell) {
        
        switch self {
        case .inline:
            cell.textLabel?.textColor = cell.tintColor
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.numberOfLines = 1
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        case .centered:
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = cell.tintColor
            cell.textLabel?.numberOfLines = 1
            cell.accessoryType = .none
            cell.selectionStyle = .default
        case .text:
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.numberOfLines = 0
            cell.accessoryType = .none
            cell.selectionStyle = .none
        }
    }
}

extension Agreement.Section {
    
    var rowStyle: MultiPartAgreementViewController.RowStyle {
        switch self {
        case .text: return .text
        case .callToAction: return .centered
        case .link: return .inline
        }
    }
    
}


extension MultiPartAgreementViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agreementToPresent.sections.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let part = agreementToPresent.sections[indexPath.row]
        
        part.rowStyle.update(cell: cell)
        cell.textLabel?.attributedText = part.attributedText
        
        return cell
    }
}

extension MultiPartAgreementViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let part = agreementToPresent.sections[indexPath.row]
        switch part {
        case .text: break
        case .callToAction(_):
            
            let emailVC = MFMailComposeViewController()
            emailVC.setSubject(agreementToPresent.title)
            
            if let message = agreementToPresent.message {
                emailVC.setMessageBody(message, isHTML: false)
            }
            
            emailVC.mailComposeDelegate = self
            self.present(emailVC, animated: true, completion: nil)
            
        case .link(_, let url):
            let safariVC = SFSafariViewController(url: url!)
            self.present(safariVC, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
