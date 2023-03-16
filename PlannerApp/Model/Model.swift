//
//  Category.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 4/22/22.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
class Category
{
    var name: String
    var desc: String
    
    init(cName: String, cDesc: String)
    {
        name = cName
        desc = cDesc
    }
}

class Task
{
    var cat : Category
    var name: String
    var desc: String
    var hasImage : Bool
    var img: UIImage?
    
    init(cName: String, cDesc: String, c: Category, hasImage: Bool, img : UIImage? = nil)
    {
        self.name = cName
        self.desc = cDesc
        self.cat = c
        self.hasImage = hasImage
        self.img = img
        if(!hasImage || img != nil)
        {
            return
        }
        AppDelegate.sharedManagers()?.networkManager.obtainImage(taskName: name, completionHandler: self.setImage(image:))
        
    }
    
    private func setImage(image: UIImage?)
    {
        self.img = image
    }
}

