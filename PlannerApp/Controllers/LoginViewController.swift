//
//  LoginViewController.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 4/22/22.
//

import UIKit

class LoginViewController: UIViewController, AuthDelegate
{

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad()
    {
        AppDelegate.sharedManagers()?.errorManager.setDelegate(viewController: self)
        AppDelegate.sharedManagers()?.userManager.setAuthDelegate(delegate: self)
        super.viewDidLoad()
    }

    @IBAction func loginAttempt(_ sender: UIButton)
    {
        AppDelegate.sharedManagers()?.userManager.loginUserWithAuth(email: emailText.text ?? "", password: passwordText.text ?? "")
    }
    
    func segueToMain()
    {
        self.performSegue(withIdentifier: "loginSegue", sender: self)
        AppDelegate.sharedManagers()?.userManager.setAuthDelegate(delegate: nil)
    }
    
    @IBAction func unwindToLoginPage(segue:UIStoryboardSegue)
    {
        
    }
    
    
}
