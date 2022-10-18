//
//  AddCatViewController.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 4/22/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class AddCatViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var descText: UITextView!
    override func viewDidLoad() {
        AppDelegate.sharedManagers()?.errorManager.setDelegate(viewController: self)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func CategoryAddAttempt(_ sender: UIButton) {
        
        if(nameText.text == nil || descText.text == nil)
        {
            let alertController = UIAlertController(title: nil, message: "Please fill out all fields", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        }
        else
        {
            performSegue(withIdentifier: "addUnwind", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "addUnwind")
        {
            AppDelegate.sharedManagers()?.userManager.addCategory(category: Category(cName: nameText.text!, cDesc: descText.text!))

        }
    }
}
