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
    var long: Float?
    var lat: Float?
    
    init(cName: String, cDesc: String, c: Category, cImg: UIImage?, cLong: Float?, cLat: Float?)
    {
        name = cName
        desc = cDesc
        cat = c
        img = cImg
        long = cLong
        lat = cLat
    }
}

