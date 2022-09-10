//
//  XHCommonFunction.swift
//  XHUtilCore
//
//  Created by 梁先华 on 2022/9/10.
//

import Foundation
import SwiftPrettyPrint

public func debuglog(_ value:Any){
    #if DEBUG
    Pretty.prettyPrint(value)
    #else
    #endif
}

public func debuglog(_ description: String = "\n",_ value:Any){
    #if DEBUG
    Pretty.prettyPrint(description)
    Pretty.prettyPrint(value)
    #else
    #endif
}


