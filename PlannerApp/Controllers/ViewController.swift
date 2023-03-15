//
//  ViewController.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 3/20/22.
//

import UIKit

class ViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }


}

extension UIViewController : PresentAlertDelegate
{
    func prepViewController()
    {
        AppDelegate.sharedManagers()?.errorManager.setDelegate(viewController: self)
        self.hideKeyboardOnTap()
    }
    
    func hideKeyboardOnTap()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    
    
}

