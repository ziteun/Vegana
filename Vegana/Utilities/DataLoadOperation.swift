//
//  DataLoadOperation.swift
//  vegana
//
//  Created by DongUk Kim on 2022/01/01.
//  Copyright © 2022 VEGANA. All rights reserved.
//

import Foundation
import UIKit

class DataPrefetchOperation: Operation {

    let imageUrl: String
    
    init(with url:String) {
        self.imageUrl = url
    }
    
    override func main() {
        if isCancelled { return }
            // fire a download
        ImageFetcherHelper.loadImage(with: self.imageUrl)
    }
}

struct ImageFetcherHelper {
    static func loadImage(with url: String) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            imageCache[url.absoluteString] = photoImage
        }.resume()
    }
}
