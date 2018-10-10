//
//  Tools.swift
//  Anagram
//
//  Created by Krzysztof Grobelny on 10/10/2018.
//  Copyright © 2018 Mobica. All rights reserved.
//

import Foundation

typealias VoidClosure = () -> ()

public func runOnMainThread(_ block: @escaping () -> Void)
{
    if Thread.isMainThread {
        block()
    }
    else {
        DispatchQueue.main.async {
            block()
        }
    }
}
