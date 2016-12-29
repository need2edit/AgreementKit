//
//  Constraints.swift
//  ACPTools
//
//  Created by Jake Young on 10/18/16.
//  Copyright © 2016 Nous Foundation. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Helper function for shortening visual format syntax.
    ///
    /// - parameter format: the visual format you want
    /// - parameter views:  the views in order of what you need to constrain (e.g. v0, v1, v2 can be provided as imageView, titleView, subtitleView)
    public func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    /// Constrains a view's edges to another view's edges.
    ///
    /// - parameter otherView: the view and rect to contrain each edge to
    func constrainEdges(toMarginOf otherView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        topAnchor.constraint(equalTo: otherView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: otherView.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: otherView.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: otherView.rightAnchor).isActive = true
    }
    
}

extension UIEdgeInsets {
    
    /// Total horizontal left and right spacing on insets
    var horizontalSpacing: CGFloat { return self.left + self.right }
    
    /// Total vertical top and bottom spacing on insets
    var verticalSpacing: CGFloat { return self.top + self.bottom }
}

