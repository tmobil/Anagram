//
//  ActivityIndicatorView.swift
//  Anagram
//
//  Created by Krzysztof Grobelny on 09/10/2018.
//  Copyright © 2018 Mobica. All rights reserved.
//

import UIKit

class ActivityIndicatorView: UIVisualEffectView
{
    @IBOutlet private weak var label: UILabel!

    func show(withText text: String)
    {
        UIApplication.shared.beginIgnoringInteractionEvents()
        label.text = text
        isHidden = false
    }

    func hide(withCompletion completion: VoidClosure? = nil)
    {
        runOnMainThread {
            UIApplication.shared.endIgnoringInteractionEvents()
            self.isHidden = true
            completion?()
        }
    }
}
