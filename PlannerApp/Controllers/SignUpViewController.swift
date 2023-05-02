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
    @IBOutlet weak var confirmPasswordText : UITextField!
    override func viewDidLoad()
    {
        self.prepViewController()
        AppDelegate.sharedManagers()?.userManager.setAuthDelegate(delegate: self)
        super.viewDidLoad()
    }
    
    @IBAction func signUpAttempt(_ sender: UIButton)
    {
        if(passwordsDoMatch(passwordText.text ?? "", confirmPasswordText.text ?? ""))
        {
            AppDelegate.sharedManagers()?.userManager.signUpUserWithAuth(email: emailText.text ?? "", password: passwordText.text ?? "")
        }
        else
        {
            AppDelegate.sharedManagers()?.errorManager.handleError(error: CreateError.PasswordsDontMatch)
        }
        
    }
    
    private func passwordsDoMatch(_ password1 : String, _ password2 : String) -> Bool
    {
        return password1 == password2
    }
    
    
    func segueToMain()
    {
        self.performSegue(withIdentifier: "signUpSegue", sender: self)
        AppDelegate.sharedManagers()?.userManager.setAuthDelegate(delegate: nil)
    }
    
    

}
