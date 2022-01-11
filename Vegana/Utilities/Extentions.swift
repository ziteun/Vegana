//
//  Extentions.swift
//  vegana
//
//  Created by DongUk Kim on 2022/01/01.
//  Copyright © 2022 VEGANA. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}


extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?,
                left: NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                right: NSLayoutXAxisAnchor?,
                paddingTop: CGFloat,
                paddingLeft: CGFloat,
                paddingBottom: CGFloat,
                paddingRight: CGFloat,
                width: CGFloat,
                height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension Date {
    func displayTimeAgo() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60*60
        let day = 60*60*24
        let week = 60*60*24*7
        
        if secondsAgo < minute {
            return "\(secondsAgo) seconds ago"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) minutes ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hours ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) days ago"
        } else {
            return "\(secondsAgo / week) weeks ago"
        }
    }
    
    func dateWithoutTime() -> Date {
        let timeZone = TimeZone.current
        let timeIntervalWithTimeZone = self.timeIntervalSinceReferenceDate + Double(timeZone.secondsFromGMT())
        let timeInterval = floor(timeIntervalWithTimeZone / 86400) * 86400
        return Date(timeIntervalSinceReferenceDate: timeInterval)
    }
}

extension String {
    func getEdtimatedHeight(width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        let estimatedSize = NSString(string: self).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return estimatedSize.height
    }
}

extension UIViewController {
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */
    var navigationBarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}

extension UIScrollView {
    func resizeScrollViewContentSize() {
        var contentRect = CGRect.zero
        for view in self.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.contentSize = contentRect.size
    }
}
