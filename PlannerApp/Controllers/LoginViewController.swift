//
//  LoginViewController.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 4/22/22.
//

import UIKit

class LoginViewController: UIViewController
{

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad()
    {
        AppDelegate.sharedManagers()?.errorManager.setDelegate(viewController: self)
        super.viewDidLoad()
    }

    @IBAction func loginAttempt(_ sender: UIButton) {
        AppDelegate.sharedManagers()?.userManager.loginUser(email: emailText.text!, password: passwordText.text!)
    }
    
    @IBAction func unwindToLoginPage(segue:UIStoryboardSegue)
    {
        
    }
}
