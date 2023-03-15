//
//  SignUpViewController.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 4/22/22.
//

import UIKit
import FirebaseAuth
class SignUpViewController: UIViewController, AuthDelegate
{

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    var success: Bool = false
    override func viewDidLoad()
    {
        self.prepViewController()
        AppDelegate.sharedManagers()?.userManager.setAuthDelegate(delegate: self)
        super.viewDidLoad()
    }
    
    @IBAction func signUpAttempt(_ sender: UIButton)
    {
        AppDelegate.sharedManagers()?.userManager.signUpUserWithAuth(email: emailText.text ?? "", password: passwordText.text ?? "")
    }
    
    
    func segueToMain()
    {
        self.performSegue(withIdentifier: "signUpSegue", sender: self)
        AppDelegate.sharedManagers()?.userManager.setAuthDelegate(delegate: nil)
    }
    
    

}
