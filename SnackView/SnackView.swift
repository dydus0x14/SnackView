/*
*
*  SnackView.swift
*
*  Created by Anton Davydov on 26/01/2016.
*  Copyright © 2016 Anton Davydov. All rights reserved.
*
* ----------------------------------------------------------------------------
* "THE BEER-WARE LICENSE" (Revision 42):
* dydus0x14 wrote this file.  As long as you retain this notice you
* can do whatever you want with this stuff. If we meet some day, and you think
* this stuff is worth it, you can buy me a beer in return.   
* ----------------------------------------------------------------------------
*/

import UIKit
import Cartography

struct Margin {
    let left: CGFloat
    let right: CGFloat
    let top: CGFloat
    let bottom: CGFloat
}

enum StackViewDirection: Int {
    case Horizontal
    case Vertical
}

@IBDesignable class SnackView: UIView {

    private let constrainGroup = ConstraintGroup()
    private(set) var direction: StackViewDirection = .Horizontal {
        didSet {
            layout()
        }
    }
    
    private(set) var margin = Margin(left: 0, right: 0, top: 0, bottom: 0) {
        didSet {
            layout()
        }
    }
    
    private(set) var space: CGFloat = 0 {
        didSet {
            layout()
        }
    }
    
    init(direction: StackViewDirection, margin: Margin = Margin(left: 0, right: 0, top: 0, bottom: 0)) {
        super.init(frame: CGRectZero)
        self.direction = direction
        self.margin = margin
    }
    
    func addAll(views views: [UIView]) {
        views.forEach{ addSubview($0) }
        layout()
    }
    
    func add(view view: UIView) {
        addSubview(view)
        layout()
    }
    
    func clear() {
        subviews.forEach{ $0.removeFromSuperview() }
        layout()
    }
    
    convenience init() {
        self.init(direction: .Horizontal)
        layout()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout()
    }

    private func layout() {
        if direction == .Horizontal {
            constrain(subviews, replace: constrainGroup) { views in
                for (index, view) in views.enumerate() {
                    view.top == view.superview!.top + self.margin.top
                    view.bottom == view.superview!.bottom - self.margin.bottom
                    
                    if index == 0 {
                        view.left == view.superview!.left + self.margin.left
                    } else {
                        views[index].left == views[index-1].left + space
                    }
                }
                
                if let last = views.last {
                    last.right == last.superview!.right - self.margin.right
                }
            }
        } else {
            constrain(subviews, replace: constrainGroup) { views in
                for (index, view) in views.enumerate() {
                    view.left == view.superview!.left + self.margin.left
                    view.right == view.superview!.right - self.margin.right
                    
                    if index == 0 {
                        view.top == view.superview!.top + self.margin.top
                    } else {
                        views[index].top == views[index-1].bottom + space
                    }
                }
                
                if let last = views.last {
                    last.bottom == last.superview!.bottom - self.margin.bottom
                }
            }
        }
        
        layoutIfNeeded()
    }
}

// MARK: - Inspectable properties
extension SnackView {
    @IBInspectable private(set) var DesignableDirection: Int {
        get {
            return direction.rawValue
        } set {
            direction = StackViewDirection(rawValue: newValue) ?? .Vertical
        }
    }
    
    @IBInspectable var DesignableSpace: CGFloat {
        get {
            return space
        } set {
            space = newValue
        }
    }
    
    @IBInspectable var leftMargin: CGFloat {
        get {
            return margin.left
        } set {
            margin = Margin(left: newValue, right: margin.right, top: margin.top, bottom: margin.bottom)
        }
    }
    
    @IBInspectable var rightMargin: CGFloat {
        get {
            return margin.right
        } set {
            margin = Margin(left: margin.left, right: newValue, top: margin.top, bottom: margin.bottom)
        }
    }
    
    @IBInspectable var topMargin: CGFloat {
        get {
            return margin.top
        } set {
            margin = Margin(left: margin.left, right: margin.right, top: newValue, bottom: margin.bottom)
        }
    }
    
    @IBInspectable var bottomMargin: CGFloat {
        get {
            return margin.bottom
        } set {
            margin = Margin(left: margin.left, right: margin.right, top: margin.top, bottom: newValue)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layout()
    }
}

