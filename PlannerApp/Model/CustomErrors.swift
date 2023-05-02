//
//  CustomErrors.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 10/17/22.
//

import Foundation
enum FirebaseError: LocalizedError
{
    case userDataFetchFailed
    case corruptTask
    
    public var errorDescription: String?
    {
        switch self
        {
            case .userDataFetchFailed:
                return NSLocalizedString(
                    "User Data is not available at this time.",
                    comment: "Data Fetch Failed"
                )
            
            case .corruptTask:
                return NSLocalizedString(
                    "That task is not available at this time.",
                    comment: "Corrupt Task"
                )
            }
        }
    
}

enum CreateError : LocalizedError
{
    case FillOutAllFields
    case PasswordsDontMatch
    case NoCategory
    
    public var errorDescription: String?
    {
        switch self
        {
            case .FillOutAllFields:
                return NSLocalizedString("Please fill out all fields", comment: "Fields Error")
            
            case .PasswordsDontMatch:
                return NSLocalizedString("Passwords do not match", comment: "Password Match Error")
            
            case .NoCategory:
                return NSLocalizedString("Please add a Category", comment: "Category Error")
            
            
        }
    }
}
