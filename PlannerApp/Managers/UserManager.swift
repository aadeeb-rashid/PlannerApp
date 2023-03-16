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
    
    func findCategoryByName(name: String) -> Category?
    {
        for category in categoryList
        {
            if (category.name == name)
            {
                return category
            }
        }
        return nil
    }
    
    func resetCategories()
    {
        categoryList = []
    }
    
    func getTasks() -> [Task]
    {
        return taskList
    }
    
    func addTask(task : Task)
    {
        taskList.append(task)
    }
    
    func addNewTask(img : UIImage?, taskName: String, taskDescription : String ,categoryIndex : Int)
    {
        let newTask : Task = Task(cName: taskName, cDesc: taskDescription, c: self.getCategoryAt(index: categoryIndex), hasImage: img != nil, img: img)
        taskList.append(newTask)
        AppDelegate.sharedManagers()?.networkManager.addTaskToDatabase(img: img, taskName: taskName, taskDescription: taskDescription, categoryIndex: categoryIndex)
    }
    
    func resetTasks()
    {
        taskList = []
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
    
    private func handleFailedAuthAttempt(error: Error)
    {
        AppDelegate.sharedManagers()?.errorManager.handleError(error: error)
    }
    
    private func handleSucessfullAuthAttempt()
    {
        self.userID = Auth.auth().currentUser!.uid
        self.loadUserData()
    }
    
    private func loadUserData()
    {
        AppDelegate.sharedManagers()?.networkManager.loadCategories()
        {
            AppDelegate.sharedManagers()?.networkManager.loadTasks()
            {
                self.authDelegate?.segueToMain()
            }
        }
    }
    
    
    
    
    
}
