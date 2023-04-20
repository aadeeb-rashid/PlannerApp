//
//  NetworkManager.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 10/17/22.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import UIKit
class NetworkManager: Manager
{
    //Make This a User Defined Setting at One Point or Check If it is the Default like StorageRef
    private let databaseRef : DatabaseReference = Database.database(url: "https://planningapp-d4bb4-default-rtdb.firebaseio.com/").reference()
    private let storageRef:StorageReference = Storage.storage().reference()
    
    
    func getDatabaseRef() -> DatabaseReference
    {
        return databaseRef
    }
    
    func getStorage() -> StorageReference
    {
        return storageRef
    }
    
    func addCategoryToDatabase(category: Category)
    {
        let userID : String = (AppDelegate.sharedManagers()?.userManager.getUserId())!
        self.databaseRef.child("users/\(String(describing: userID))/Categories/\(String(describing: category.name))").setValue(category.desc)
    }
    
    func loginUserWithParameters(email:String, password:String, completionHandler: @escaping (Error?) -> Void)
    {
        Auth.auth().signIn(withEmail: email, password: password)
        { (_, error) in
            completionHandler(error)
        }
    }
    
    func signUpUserWithParameters(email: String, password: String, completionHandler: @escaping (Error?) -> Void)
    {
        Auth.auth().createUser(withEmail: email, password: password)
        {
            (_, error) in
            completionHandler(error)
        }
    }
    
    func addTaskToDatabase(img : UIImage?, taskName: String, taskDescription : String ,categoryIndex : Int)
    {
        let userID : String = (AppDelegate.sharedManagers()?.userManager.getUserId())!
        if let img = img
        {
            var data = NSData()
            data = img.jpegData(compressionQuality: 0.8)! as NSData
            // set upload path
            let filePath = "\(String(describing: userID))/\(taskName)"
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            self.storageRef.child(filePath).putData(data as Data, metadata: metaData)
            {(metaData,error) in
                if let error = error
                {
                    AppDelegate.sharedManagers()?.errorManager.handleError(error: error)
                    return
                }
            }
            self.databaseRef.child("users/\(String(describing: userID))/Tasks/\(taskName)/img").setValue(true)
        }
        else
        {
            self.databaseRef.child("users/\(String(describing: userID))/Tasks/\(taskName)/img").setValue(false)
        }
        self.databaseRef.child("users/\(String(describing: userID))/Tasks/\(taskName)/desc").setValue(taskDescription)
        self.databaseRef.child("users/\(String(describing: userID))/Tasks/\(taskName)/cat").setValue(AppDelegate.sharedManagers()?.userManager.getCategoryAt(index: categoryIndex).name)
    }
    
    
    func loadCategories(completionHandler: @escaping () -> Void)
    {
        AppDelegate.sharedManagers()?.userManager.resetCategories();
        self.fetchCategoriesFromFirebase()
        {firebaseCategories in
            self.convertFirebaseCategories(firebaseCategories: firebaseCategories)
            {
                completionHandler()
            }
        }
    }
    
    private func fetchCategoriesFromFirebase(completionHandler: @escaping (NSDictionary) -> Void)
    {
        let userID : String = (AppDelegate.sharedManagers()?.userManager.getUserId())!
        self.databaseRef.child("users/\(String(describing: userID))/Categories").observeSingleEvent(of: .value, with:
        { snapshot in
            self.validateSnapshotWithCompletion(snapshot: snapshot)
            {categoryDictionary in
                
                completionHandler(categoryDictionary)
            }
        })
    }
    
    private func validateSnapshotWithCompletion(snapshot : DataSnapshot, completionHandler : @escaping (NSDictionary) -> Void)
    {
        if let value = snapshot.value as? NSDictionary
        {
            completionHandler(value)
            return
        }
        completionHandler([:])
    }
    
    private func convertFirebaseCategories(firebaseCategories: NSDictionary, completionHandler: @escaping () -> Void)
    {
        for (catName,catDesc) in firebaseCategories
        {
            if(canConvertToString(catName) && canConvertToString(catDesc))
            {
                let category : Category = Category(cName: catName as! String, cDesc: catDesc as! String)
                AppDelegate.sharedManagers()?.userManager.addCategory(category: category)
            }
        }
        completionHandler()
    }
    
    private func canConvertToString(_ content : Any) -> Bool
    {
        return content is String
    }
    
    func loadTasks(completionHandler: @escaping () -> Void)
    {
        
        AppDelegate.sharedManagers()?.userManager.resetTasks()
        self.fetchTasksFromFirebase()
        {firebaseTasks in
            self.convertFirebaseTasks(firebaseTasks: firebaseTasks)
            {
                completionHandler()
            }
        }
        
    }
    
    private func fetchTasksFromFirebase(completionHandler: @escaping (NSDictionary) -> Void)
    {
        let userID : String = (AppDelegate.sharedManagers()?.userManager.getUserId())!
        self.databaseRef.child("users/\(String(describing: userID))/Tasks").observeSingleEvent(of: .value, with:
        { snapshot in
            self.validateSnapshotWithCompletion(snapshot: snapshot)
            {taskDictionary in
                completionHandler(taskDictionary)
            }
        })
    }
    
    private func convertFirebaseTasks(firebaseTasks : NSDictionary, completionHandler: @escaping () -> Void)
    {
        for(taskName, taskObj) in firebaseTasks
        {
            self.validateTask(taskObject: taskObj)
            {taskObject in
                self.convertFirebaseTask(taskName: taskName as! String, taskObject: taskObject)
            }
        }
        completionHandler()
    }
    
    private func validateTask(taskObject: Any,completionHandler: @escaping (NSDictionary?) -> Void)
    {
        if let value = taskObject as? NSDictionary
        {
            completionHandler(value)
            return
        }
        completionHandler(nil)
    }
    
    private func convertFirebaseTask(taskName : Any, taskObject: NSDictionary?)
    {
        if let taskObject = taskObject, self.canConvertToString(taskName)
        {
            let taskName = taskName as! String
            let categoryName: String = taskObject["cat"] as? String ?? "TCategory"
            let description : String = taskObject["desc"] as? String ?? "TDescription"
            let hasImage: Bool = taskObject["img"] as? Bool ?? false
            if let category = AppDelegate.sharedManagers()?.userManager.findCategoryByName(name: categoryName)
            {
                AppDelegate.sharedManagers()?.userManager.addTask(task: Task(cName: taskName, cDesc: description, c: category, hasImage: hasImage))
            }
        }
    }
    
    func obtainImage(taskName: String, completionHandler: @escaping (UIImage?) -> Void)
    {
        let image : UIImage? = ImageCache.getImageForName(name: taskName)
        if(image != nil)
        {
            completionHandler(image)
            return
        }
        
        let userID : String = (AppDelegate.sharedManagers()?.userManager.getUserId())!
        let filePath = "\(String(describing: userID))/\(taskName)"
        
        // Assuming a < 50MB file, though you can change that
        self.storageRef.child(filePath).getData(maxSize: 50*1024*1024)
        {data,error in
            if let data = data, error == nil
            {
                let image = UIImage(data: data)
                ImageCache.setImageForName(name: taskName, image: image)
                completionHandler(image)
                return
            }
            completionHandler(nil)
            return
        }
        completionHandler(nil)
        return
    }
    
    func sendForgottenPasswordEmail(emailAddress: String)
    {
        Auth.auth().sendPasswordReset(withEmail: emailAddress, completion: AppDelegate.sharedManagers()?.errorManager.handlePotentialError(_:))
    }
    
    
    
}
