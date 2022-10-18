//
//  UserManager.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 9/14/22.
//

import Foundation
import FirebaseAuth
import UIKit
class UserManager: Manager
{
    
    private var userID: String?
    private var categoryList: [Category]
    private var taskList: [Task]
    
    override init()
    {
        self.userID = nil
        self.categoryList = []
        self.taskList = []
    }
    
    func getUserId() -> String?
    {
        return userID
    }
    
    func getCategories() -> [Category]
    {
        return categoryList
    }
    
    
    func addCategory(category : Category)
    {
        self.categoryList.append(category)
        AppDelegate.sharedManagers()?.networkManager.addCategoryToDatabase(category: category)
    }
    
    
    func getTasks() -> [Task]
    {
        return taskList
    }
    
    func loginUser(email:String, password:String)
    {
        AppDelegate.sharedManagers()?.networkManager.loginUser(email: email, password: password)
        { (error) in
            if let error = error
            {
                self.handleFailedLoginAttempt(error: error)
            }
            else
            {
                self.handleSucessfulLoginAttempt()
            }
        }
    }
    
    private func handleSucessfulLoginAttempt()
    {
        userID = Auth.auth().currentUser!.uid
        AppDelegate.sharedManagers()?.networkManager.setDataFromAccount()
        {categoryList,taskList in
            
            self.categoryList = categoryList
            self.taskList = taskList
            LoginViewController().performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    private func handleFailedLoginAttempt(error: Error)
    {
        AppDelegate.sharedManagers()?.errorManager.handleError(error: error)
    }
    
    
}
