//
//  MySwiftEnvItem.swift
//  HyperioniOSExtensionDemo
//
//  Created by TBD on 2018/4/19.
//  Copyright © 2018年 TBD. All rights reserved.
//

import Foundation
#if CUSTOM_DEBUG
import HyperioniOSExtension
#endif

// Swift Item Example
#if CUSTOM_DEBUG
@objcMembers
class MySwiftEnvItem: NSObject, HYPEnvironmentItemProtocol {
    var name: String?
    var baseURL: String?
    var commonPort: String?
    var H5BaseURL1: String?
    var H5BaseURL2: String?
    var H5BaseURL3: String?
    var H5BaseURL4: String?
    required override init() {
        super.init()
    }
    
    init(name: String) {
        super.init()
        self.name = name
    }
}
#else
@objcMembers
class MySwiftEnvItem: NSObject {
    var name: String?
    var baseURL: String?
    var commonPort: String?
    var H5BaseURL1: String?
    var H5BaseURL2: String?
    var H5BaseURL3: String?
    var H5BaseURL4: String?
    required override init() {
        super.init()
    }
    
    init(name: String) {
        super.init()
        self.name = name
    }
}
#endif
