//
//  UserProfilePhotoCell.swift
//  vegana
//
//  Created by DongUk Kim on 2022/01/01.
//  Copyright © 2022 VEGANA. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: imageUrl)
        }
    }

    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .tertiarySystemBackground
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    private func sharedInit() {
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
