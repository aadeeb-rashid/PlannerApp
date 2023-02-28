//
//  UserManager.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 9/14/22.
//

import Foundation
import FirebaseAuth
import UIKit

protocol AuthDelegate : UIViewController
{
    func segueToMain()
}

class UserManager: Manager
{
    
    private var userID: String?
    private var categoryList: [Category]
    private var taskList: [Task]
    private var authDelegate : AuthDelegate?
    
    override init()
    {
        self.userID = nil
        self.categoryList = []
        self.taskList = []
        self.authDelegate = nil
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
    
    func getCategoryAt(index : Int) -> Category
    {
        return self.categoryList[index]
    }
    
    func getTasks() -> [Task]
    {
        return taskList
    }
    
    func addTask(task : Task)
    {
        taskList.append(task)
    }
    
    func setAuthDelegate(delegate : AuthDelegate?)
    {
        self.authDelegate = delegate
    }
    
    func loginUserWithAuth(email:String, password:String)
    {
        AppDelegate.sharedManagers()?.networkManager.loginUserWithParameters(email: email, password: password)
        { error in
            if let error = error
            {
                self.handleFailedAuthAttempt(error: error)
            }
            else
            {
                self.handleSucessfullAuthAttempt()
            }
        }
    }
    
    func signUpUserWithAuth(email:String, password:String)
    {
        AppDelegate.sharedManagers()?.networkManager.signUpUserWithParameters(email: email, password: password)
        {error in
            if let error = error
            {
                self.handleFailedAuthAttempt(error: error)
            }
            else
            {
                self.handleSucessfullAuthAttempt()
            }
        }
    }
    
    private func handleSucessfullAuthAttempt()
    {
        self.userID = Auth.auth().currentUser!.uid
        AppDelegate.sharedManagers()?.networkManager.setDataFromAccount()
        {categoryList,taskList in
            
            self.categoryList = categoryList
            self.taskList = taskList
            self.authDelegate?.segueToMain()
        }
    }
    
    private func handleFailedAuthAttempt(error: Error)
    {
        AppDelegate.sharedManagers()?.errorManager.handleError(error: error)
    }
    
    
    
    
}
