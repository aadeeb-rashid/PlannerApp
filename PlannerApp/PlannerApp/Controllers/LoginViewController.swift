//
//  LoginViewController.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 4/22/22.
//

import UIKit
import FirebaseAuth



class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    var success: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToLoginPage(segue:UIStoryboardSegue)
    {
        
    }
 

    @IBAction func loginAttempt(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (result, error) in
            var message:String
                if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                    message = error.localizedDescription
                    self.success = false
                } else {
                    message = "Logged in Sucessfully."
                    self.success = true
                }
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in
                if(self.success)
                {
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }))
            if(self.success)
            {
                UserData.userID = Auth.auth().currentUser!.uid
                self.setData()
                
            }
            self.present(alertController, animated: true)
            }
    }
    
    func setData()
    {
        UserData.ref.child("users/\(UserData.userID)/Categories").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            if let value = snapshot.value as? NSDictionary
            {
                for (catName,catDesc) in value
                {
                    UserData.catList.append(Category(cName: catName as! String, cDesc: catDesc as! String))
                }
                UserData.ref.child("users/\(UserData.userID)/Tasks").observeSingleEvent(of: .value, with: { snapshot in
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
                                let filePath = "\(UserData.userID)/\(taskName as! String)"
                                var img : UIImage? = nil
                                  
                                // Assuming a < 10MB file, though you can change that
                                print(im)
                                if(im)
                                {
                                    UserData.storage.child(filePath).getData(maxSize: 10*1024*1024, completion:
                                    { (data, error) in
                                                        
                                        img = UIImage(data: data!)
                                        var cate : Category? = nil
                                        for ca in UserData.catList
                                        {
                                            if(ct == ca.name)
                                            {
                                                cate = ca
                                                UserData.taskList.append(Task(cName: taskName as! String, cDesc: desc, c: cate!, cImg: img , cLong: long, cLat: lat))
                                                break;
                                            }
                                        }
                                    })
                                    
                                }
                                //print(img == nil)
                                
                                
                                
                            }
                            
                        }
                        
                    }
                })
            }
        })
    }
}
