//
//  CollectionViewHelpers.swift
//  ACPTools
//
//  Created by Jake Young on 10/21/16.
//  Copyright © 2016 Nous Foundation. All rights reserved.
//

import UIKit

extension UITableView {
    
    
    /// Registers any UITableViewCell using the class name as the unique identifier.
    public func registerCell<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing:T.self))
    }
    
    
    /// Registers any UITableViewHeaderFooterView using the class name as the unique identifier.
    public func registerHeaderFooterCell<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
    }
    
    /// Returns any subclass of UITableViewHeaderFooterView safely typed.
    ///
    /// ```
    /// let cell: CustomHeader = tableView.dequeueReusableHeaderFooterView(CustomHeader.self)
    public func dequeueHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        
        guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Could not dequeue header footer with identifier: \(String(describing: T.self))")
        }
        
        return headerFooter
    }
    
    /// Returns any subclass of UITableViewCell safely typed.
    ///
    /// ```
    /// let cell: CustomCell = tableView.dequeueReusableCell(CustomCell.self, for: indexPath)
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
        }
        
        return cell
    }
}
