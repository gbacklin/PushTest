//
//  BadgeImageView.swift
//  BadgeDemo
//
//  Created by Gene Backlin on 10/16/19.
//  Copyright © 2019 Gene Backlin. All rights reserved.
//

import UIKit

class BadgeImageView: UIImageView {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func textToImage(drawText text: String, inImage newImage: UIImage, atPoint point: CGPoint) {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 12)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(newImage.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        newImage.draw(in: CGRect(origin: CGPoint.zero, size: newImage.size))
        
        let rect = CGRect(origin: point, size: newImage.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

}
