//
//  Message.swift
//  vegana
//
//  Created by DongUk Kim on 2022/01/01.
//  Copyright © 2022 VEGANA. All rights reserved.
//

import Foundation

import Foundation

struct Message {
    var fromId: String
    var text: String
    var toId: String
    var timeStamp: Double
    
    init(dictionary: [String: Any]) {
        fromId = dictionary["fromId"] as? String ?? ""
        text = dictionary["text"] as? String ?? ""
        toId = dictionary["toId"] as? String ?? ""
        timeStamp = dictionary["timeStamp"] as? Double ?? 0
    }
    
}

