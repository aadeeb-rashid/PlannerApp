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
    var name: String?
    var desc: String?
    
    init(cName: String, cDesc: String)
    {
        name = cName
        desc = cDesc
    }
}

class Task
{
    var cat : Category
    var name: String?
    var desc: String?
    var img: UIImage?
    
    init(cName: String, cDesc: String, c: Category, cImg: UIImage?)
    {
        name = cName
        desc = cDesc
        cat = c
        img = cImg
    }
}

