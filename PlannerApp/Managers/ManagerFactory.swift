//
//  ManagerFactory.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 9/15/22.
//

import Foundation

class Manager
{
    
}

class ManagerFactory
{
    var managers: [Manager] = []
    lazy var userManager: UserManager =
    {
        let manager = UserManager()
        self.managers.append(manager)
        return manager
    }()
    
    lazy var errorManager: ErrorManager =
    {
        let manager = ErrorManager()
        self.managers.append(manager)
        return manager
    }()
    
    lazy var networkManager: NetworkManager =
    {
        let manager = NetworkManager()
        self.managers.append(manager)
        return manager
    }()
}
