//
//  UINavigationController + preferredStatusBarStyle.swift
//  GrubGab
//
//  Created by John Gallaugher on 11/20/17.
//  Copyright © 2017 John Gallaugher. All rights reserved.
//


// NOTE: new .swift files normally only import foundation, but we needed UIKit here because we were extending UINavigationController, which Foundation doesn't know about, but UIKit does.
// Setting .preferredStatusBarStyle = .lightContent will turn the top status bar (battary indicators, signal strength, time) to white instead of standard black.
// BUT you normally can't do this, so you need this extension, plus in each of your view controllers that are embedded in a navigation controller you need to add the code below as a class-wide (instance) variable declaration at the top of the file.

/*
override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
}
*/


import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }
}
