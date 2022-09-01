//
//  APIStruct.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 4/22/22.
//

import Foundation
struct List:Codable
{
    let lat: Float?
    let lon: Float?
    let current: Elm
}

struct Elm:Codable
{
    let weather: [Elm2]
}

struct Elm2: Codable
{
    let id : Int
    let main: String
    let description: String
    let icon: String
}
