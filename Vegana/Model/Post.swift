//
//  Post.swift
//  vegana
//
//  Created by DongUk Kim on 2022/01/01.
//  Copyright © 2022 VEGANA. All rights reserved.
//

import Foundation

struct Post {
    
    var id: String?
    let user: User
    let imageUrl: String
    let caption: String
    let creationDate: Date
    var hasLiked = false
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        hasLiked = dictionary["hasLiked"] as? Bool ?? false
    }
}
