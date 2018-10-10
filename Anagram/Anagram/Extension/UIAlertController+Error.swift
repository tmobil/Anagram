//
//  UIAlertController+Error.swift
//  Anagram
//
//  Created by Krzysztof Grobelny on 10/10/2018.
//  Copyright © 2018 Mobica. All rights reserved.
//

import UIKit

extension UIAlertController
{
    class func errorAlert(withMessage message: String, handler: VoidClosure? = nil) -> UIAlertController
    {
        return alert(withTitle: "Error", message: message, handler: handler)
    }

    class func infoAlert(withMessage message: String, handler: VoidClosure? = nil) -> UIAlertController
    {
        return alert(withTitle: "Info", message: message, handler: handler)
    }

    private class func alert(withTitle title: String?, message: String, handler: VoidClosure? = nil) -> UIAlertController
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
            handler?()
        }
        alertController.addAction(action)
        return alertController
    }

}
