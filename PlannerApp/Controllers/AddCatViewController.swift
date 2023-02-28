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
    override func viewDidLoad()
    {
        AppDelegate.sharedManagers()?.errorManager.setDelegate(viewController: self)
        super.viewDidLoad()
    }
    
    @IBAction func CategoryAddAttempt(_ sender: UIButton)
    {
        if(nameText.text == nil || descText.text == nil)
        {
            AppDelegate.sharedManagers()?.errorManager.handleError(error: CreateError.FillOutAllFields)
            return
        }
        self.performSegue(withIdentifier: "addUnwind", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "addUnwind")
        {
            AppDelegate.sharedManagers()?.userManager.addCategory(category: Category(cName: nameText.text ?? "", cDesc: descText.text ?? ""))

        }
    }
}
