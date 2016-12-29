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

enum RowStyle {
    case inline
    case centered
    case text
}

extension RowStyle {
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

public class MultiPartAgreementViewController: AgreementViewController {

    
    var sections: [SectionPart] {
        return [
            .text("Section 1", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus a lorem nec dui malesuada fringilla ac nec nulla. Fusce iaculis tempus elementum. Maecenas facilisis dui varius urna tincidunt, ut lobortis mi interdum. Integer dapibus lobortis ligula id commodo. Vestibulum varius in mi sit amet cursus. Nunc metus sem, tempor sed nisi vitae, placerat facilisis dolor. Phasellus porta leo non ex convallis fermentum. Duis erat dui, feugiat nec ullamcorper vitae, feugiat in justo. Vivamus eu eros convallis, malesuada eros quis, varius erat. Curabitur at egestas ligula, id sagittis mauris. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Etiam sed rutrum ex, ut blandit odio. Integer malesuada quam aliquam, finibus enim vel, suscipit est. Quisque dapibus elit non ligula tristique mattis."),
            .link("A. Website", URL(string: "https://www.apple.com/")),
            .text("Section 2", "Nulla dictum laoreet turpis, quis ultricies tellus feugiat consequat. Duis ornare efficitur risus vitae aliquet. Phasellus sed condimentum dui, id aliquet tellus. Sed congue massa nibh, vel accumsan erat eleifend sed. Sed nec porttitor ligula, non facilisis massa. Integer porttitor, ante id dignissim accumsan, velit lectus dictum turpis, eu convallis mauris ligula at orci. Morbi sit amet tortor lectus."),
            .link("B. Another Website", URL(string: "https://www.apple.com/")),
            .text("Section 3", "Sed placerat nibh id metus blandit varius. Vivamus et maximus mi. Nulla facilisi. Nullam in justo sed lacus condimentum ultrices sed vitae sem. Cras vestibulum ipsum et posuere interdum. Nunc libero leo, convallis et aliquam at, volutpat quis tortor. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis et nibh leo. Integer rhoncus eget dolor sit amet congue. In pretium lorem quis diam eleifend, et varius massa dapibus. Mauris varius neque nunc, eget aliquam eros venenatis vel. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas imperdiet purus id nisi maximus, ac volutpat felis pharetra. Morbi ut fringilla ante. Nulla accumsan, elit ac molestie tristique, metus dolor sollicitudin nibh, non molestie est eros at diam. Maecenas a nisi ut ligula condimentum blandit ut eu est."),
            .link("C. Even Another Website", URL(string: "https://www.apple.com/")),
            .text("Section 4", "Sed placerat nibh id metus blandit varius. Vivamus et maximus mi. Nulla facilisi. Nullam in justo sed lacus condimentum ultrices sed vitae sem. Cras vestibulum ipsum et posuere interdum. Nunc libero leo, convallis et aliquam at, volutpat quis tortor. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis et nibh leo. Integer rhoncus eget dolor sit amet congue. In pretium lorem quis diam eleifend, et varius massa dapibus. Mauris varius neque nunc, eget aliquam eros venenatis vel. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas imperdiet purus id nisi maximus, ac volutpat felis pharetra. Morbi ut fringilla ante. Nulla accumsan, elit ac molestie tristique, metus dolor sollicitudin nibh, non molestie est eros at diam. Maecenas a nisi ut ligula condimentum blandit ut eu est."),
            .callToAction("Send via Email")
        ]
    }
    
    enum SectionPart {
        case text(String, String)
        case callToAction(String)
        case link(String, URL?)
        
        var rowStyle: RowStyle {
            switch self {
            case .text: return .text
            case .callToAction: return .centered
            case .link: return .inline
            }
        }
        
        var attributedText: NSAttributedString {
            switch self {
            case .text(let headline, let bodyText):
                let rowText = NSMutableAttributedString(string: headline.uppercased(), attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
                
                if !bodyText.isEmpty {
                    
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


extension MultiPartAgreementViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let part = sections[indexPath.row]
        
        part.rowStyle.update(cell: cell)
        cell.textLabel?.attributedText = part.attributedText
        
        return cell
    }
}

extension MultiPartAgreementViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let part = sections[indexPath.row]
        switch part {
        case .text: break
        case .callToAction(_):
            
            let emailVC = MFMailComposeViewController()
            emailVC.setSubject(agreement.title)
            
            if let message = agreement.message {
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
