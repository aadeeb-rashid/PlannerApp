//
//  CustomErrors.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 10/17/22.
//

import Foundation
enum FirebaseError: LocalizedError {
    // Throw when DataFetch From Firebase Fails for UserData
    case userDataFetchFailed
    
    //Throw when One Task Is Corrupt
    case corruptTask
    
    public var errorDescription: String? {
            switch self {
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
