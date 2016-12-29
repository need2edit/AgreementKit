//
//  CollectionViewHelpers.swift
//  ACPTools
//
//  Created by Jake Young on 10/21/16.
//  Copyright © 2016 Nous Foundation. All rights reserved.
//

import UIKit

extension UITableView {
    
    public func registerCell<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing:T.self))
    }
    
    public func registerHeaderFooterCell<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
    }
    
    public func dequeueHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        
        guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Could not dequeue header footer with identifier: \(String(describing: T.self))")
        }
        
        return headerFooter
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
        }
        
        return cell
    }
}
