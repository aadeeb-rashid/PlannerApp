//
//  ImageCache.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 3/15/23.
//

import Foundation
import UIKit

class ImageCache
{
    private static var cache : [String:UIImage] = [:]
    
    static func getImageForName(name: String) -> UIImage?
    {
        return ImageCache.cache[name]
    }
    
    static func setImageForName(name: String, image: UIImage?)
    {
        if let image = image
        {
            ImageCache.cache[name] = image
        }
    }
    
}

extension UIImageView
{
    
}
