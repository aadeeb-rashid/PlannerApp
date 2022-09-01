//
//  SignUpViewController.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 4/22/22.
//

import UIKit
import FirebaseAuth
class SignUpViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    var success: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpAttempt(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) {(authResult, error) in
            var message: String
            if (authResult?.user) != nil {
                message = "Signed Up!"
                self.success = true

            } else {
                message = error!.localizedDescription
                self.success = false
            }
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in
                if(self.success)
                {
                    self.performSegue(withIdentifier: "signUpSegue", sender: self)
                }
            }))
            self.present(alertController, animated: true)
        }
    }

}
