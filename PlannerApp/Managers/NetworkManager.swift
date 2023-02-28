//
//  NetworkManager.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 10/17/22.
//

import Foundation
import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import UIKit
class NetworkManager: Manager
{
    //Make This a User Defined Setting at One Point or Check If it is the Default like StorageRef
    private let databaseRef : DatabaseReference = Database.database(url: "https://planner-6b8ee-default-rtdb.firebaseio.com/").reference()
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
        let userID:String? = AppDelegate.sharedManagers()?.userManager.getUserId()
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
    
    func setDataFromAccount(completionHandler: @escaping ([Category], [Task]) -> Void)
    {
        self.fetchCategoriesFromDatabase()
        {error,categoryDictionary in
            
            //try out handlePotentialError Function Later
            if let error = error
            {
                AppDelegate.sharedManagers()?.errorManager.handleError(error: error)
                completionHandler([], [])
                return
            }
            
            self.loadCategoriesFromDictionary(categoryDictionary: categoryDictionary!)
            {categoryList in
                self.setTaskList(categoryList: categoryList, completionHandler: completionHandler)
            }
        }
    }
    
    private func validateSnapshotWithCompletion(snapshot : DataSnapshot, completionHandler : @escaping (Error?, NSDictionary?) -> Void)
    {
        if let value = snapshot.value as? NSDictionary
        {
            completionHandler(nil, value)
        }
        else
        {
            completionHandler(FirebaseError.userDataFetchFailed, nil)
        }
    }
    
    private func fetchCategoriesFromDatabase(completionHandler: @escaping (Error?, NSDictionary?) -> Void)
    {
        let userID:String? = AppDelegate.sharedManagers()?.userManager.getUserId()
        self.databaseRef.child("users/\(String(describing: userID))/Categories").observeSingleEvent(of: .value, with:
        { snapshot in
            self.validateSnapshotWithCompletion(snapshot: snapshot, completionHandler: completionHandler)
        })
    }
    
    private func loadCategoriesFromDictionary(categoryDictionary: NSDictionary, completionHandler: @escaping ([Category]) -> Void)
    {
        var categoryList: [Category] = []
        for (catName,catDesc) in categoryDictionary
        {
            categoryList.append(Category(cName: catName as! String, cDesc: catDesc as! String))
        }
        completionHandler(categoryList)
    }
    
    private func setTaskList(categoryList : [Category],completionHandler: @escaping ([Category],[Task]) -> Void)
    {
        self.fetchTaskListFromDatabase()
        {error,taskDictionary in
            
            if let error = error
            {
                AppDelegate.sharedManagers()?.errorManager.handleError(error: error)
                completionHandler([], [])
            }
            self.loadTaskListFromDictionary(taskDictionary: taskDictionary!, categoryList: categoryList)
            {taskList in
                completionHandler(categoryList,taskList)
            }
        }
    }
    
    private func fetchTaskListFromDatabase(completionHandler: @escaping (Error?, NSDictionary?) -> Void)
    {
        let userID:String? = AppDelegate.sharedManagers()?.userManager.getUserId()
        self.databaseRef.child("users/\(String(describing: userID))/Tasks").observeSingleEvent(of: .value, with:
        { snapshot in
            self.validateSnapshotWithCompletion(snapshot: snapshot, completionHandler: completionHandler)
        })
    }
    
    private func loadTaskListFromDictionary(taskDictionary: NSDictionary, categoryList: [Category],completionHandler: @escaping ([Task]) -> Void)
    {
        //Check This Later it might return asynchrounously before all tasks are done loading
        var taskList : [Task] = []
        for (taskName,taskObj) in taskDictionary
        {
            self.fetchTaskFromDatabase(taskObject: taskObj)
            {error, taskDictionary in
                if let error = error
                {
                    //Delete This Task Later But For Now Skip Over it
                    print("Corrupt Task: " + error.localizedDescription)
                }
                else
                {
                    self.loadTask(taskName: taskName as! String, taskDictionary: taskDictionary!, categoryList: categoryList)
                    {task in
                        taskList.append(task)
                    }
                }
            }
            
        }
        completionHandler(taskList)
    }
    
    private func fetchTaskFromDatabase(taskObject: Any,completionHandler: @escaping (Error?, NSDictionary?) -> Void)
    {
        if let value = taskObject as? NSDictionary
        {
            completionHandler(nil, value)
        }
        else
        {
            completionHandler(FirebaseError.userDataFetchFailed, nil)
        }
    }
    
    private func loadTask(taskName: String, taskDictionary: NSDictionary, categoryList: [Category], completionHandler: @escaping (Task) -> Void)
    {
        let userID: String? = AppDelegate.sharedManagers()?.userManager.getUserId()
        let categoryString: String = taskDictionary["cat"] as? String ?? "TCategory"
        let description : String = taskDictionary["desc"] as? String ?? "TDescription"
        let longitude : Float? = taskDictionary["long"] as? Float? ?? nil
        let latitude : Float? = taskDictionary["lat"] as? Float? ?? nil
        let hasImage: Bool = taskDictionary["img"] as? Bool ?? false
        let filePath = "\(String(describing: userID))/\(taskName)"
        var img : UIImage? = nil
          
        
        if(hasImage)
        {
            self.fetchImage(filePath: filePath)
            {error, data in
                if let error = error
                {
                    AppDelegate.sharedManagers()?.errorManager.handleError(error: error)
                }
                else
                {
                    img = self.loadImage(imgData: data!)
                    self.makeTaskObjectFromData(taskName: taskName, categoryName: categoryString, description: description, longitude: longitude, latitude: latitude, img: img, categoryList: categoryList)
                    {task in
                        completionHandler(task)
                    }
                }
            }
        }
        else
        {
            self.makeTaskObjectFromData(taskName: taskName, categoryName: categoryString, description: description, longitude: longitude, latitude: latitude, img: img, categoryList: categoryList)
            {task in
                completionHandler(task)
            }
        }
        
    }
    
    private func fetchImage(filePath: String, completionHandler: @escaping (Error?, Data?) -> Void)
    {
        //Setup Image Cache
        
        // Assuming a < 10MB file, though you can change that
        self.storageRef.child(filePath).getData(maxSize: 10*1024*1024)
        {data,error in
            if let error = error
            {
                completionHandler(error, nil)
            }
            else
            {
                completionHandler(nil, data)
            }
        }
    }
    
    private func loadImage(imgData: Data) -> UIImage?
    {
        return UIImage(data: imgData)
    }
    
    private func makeTaskObjectFromData(taskName: String, categoryName: String, description: String, longitude: Float?, latitude: Float?, img: UIImage?, categoryList: [Category], completionHandler: @escaping (Task)-> Void)
    {
        let category: Category = self.findCategoryByName(name: categoryName, list: categoryList)
        let task: Task = Task(cName: taskName, cDesc: description, c: category, cImg: img, cLong: longitude, cLat: latitude)
        completionHandler(task)
    }
    
    private func findCategoryByName(name: String, list: [Category]) -> Category
    {
        for category in list
        {
            if (category.name == name)
            {
                return category
            }
        }
        return Category(cName: "Category", cDesc: "This is a Category")
    }
    
    func addTaskToDatabase(img : UIImage?, taskName: String, taskDescription : String ,categoryIndex : Int)
    {
        let userID = AppDelegate.sharedManagers()?.userManager.getUserId()
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
        
        AppDelegate.sharedManagers()?.userManager.addTask(task: Task(cName: taskName, cDesc: taskDescription, c: AppDelegate.sharedManagers()?.userManager.getCategoryAt(index: categoryIndex) ?? Category(cName: "", cDesc: ""), cImg: img))
        self.databaseRef.child("users/\(String(describing: userID))/Tasks/\(taskName)/desc").setValue(taskDescription)
        self.databaseRef.child("users/\(String(describing: userID))/Tasks/\(taskName)/cat").setValue(AppDelegate.sharedManagers()?.userManager.getCategoryAt(index: categoryIndex))
    }
    
    
    
    
    
    
    
    //Original Load Data Method That Worked
    /*func setDataFromAccount2(completionHandler: @escaping () -> Void)
    {
        let userID:String? = AppDelegate.sharedManagers()?.userManager.getUserId()
        self.databaseRef.child("users/\(String(describing: userID))/Categories").observeSingleEvent(of: .value, with:
        { snapshot in
          // Get user value
            if let value = snapshot.value as? NSDictionary
            {
                for (catName,catDesc) in value
                {
                    self.categoryList.append(Category(cName: catName as! String, cDesc: catDesc as! String))
                }
                self.databaseRef.child("users/\(String(describing: userID))/Tasks").observeSingleEvent(of: .value, with: { snapshot in
                  // Get user value
                    if let value = snapshot.value as? NSDictionary
                    {
                        for (taskName,taskObj) in value
                        {
                            if let taskDic = taskObj as? NSDictionary
                            {
                                let ct: String = taskDic["cat"] as? String ?? "TCategory"
                                let desc : String = taskDic["desc"] as? String ?? "TDescription"
                                let long : Float? = taskDic["long"] as? Float? ?? nil
                                let lat : Float? = taskDic["lat"] as? Float? ?? nil
                                let im: Bool = taskDic["img"] as? Bool ?? false
                                let filePath = "\(String(describing: userID))/\(taskName as! String)"
                                var img : UIImage? = nil
                                  
                                // Assuming a < 10MB file, though you can change that
                                if(im)
                                {
                                    self.storageRef.child(filePath).getData(maxSize: 10*1024*1024, completion:
                                    { (data, error) in
                                                        
                                        img = UIImage(data: data!)
                                        var cate : Category? = nil
                                        for ca in self.categoryList
                                        {
                                            if(ct == ca.name)
                                            {
                                                cate = ca
                                                self.taskList.append(Task(cName: taskName as! String, cDesc: desc, c: cate!, cImg: img , cLong: long, cLat: lat))
                                                break;
                                            }
                                        }
                                    })
                                    
                                }
                                
                                
                                
                            }
                            
                        }
                        
                    }
                })
            }
            else
            {
                
            }
        })
    }*/
    
}
