//
//  ErrorManager.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 9/15/22.
//

import Foundation
import UIKit

protocol PresentAlertDelegate: UIViewController
{
    
}

class ErrorManager: Manager
{
    
    private var delegate: PresentAlertDelegate?
    
    func setDelegate(viewController: PresentAlertDelegate)
    {
        delegate = viewController
    }
    
    func handlePotentialError(_ error: Error?)
    {
        if let error = error
        {
            self.handleError(error: error)
        }
    }
    
    func handleError(error: Error)
    {
        DispatchQueue.main.async
        {
            let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.delegate?.present(alertController, animated: true)
        }
    }
    
    func handleForgottenPassword()
    {
        DispatchQueue.main.async
        {
            let alertController = UIAlertController(title: nil, message: "Enter the email address for your account", preferredStyle: .alert)
            self.prepareForgottenPasswordAlert(alertController: alertController)
            self.delegate?.present(alertController, animated: true)
        }
    }
    
    private func prepareForgottenPasswordAlert(alertController : UIAlertController)
    {
        alertController.addTextField()
        { (textField) in
            textField.keyboardType = .emailAddress
            textField.placeholder = "Enter email here"
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "OK", style: .default)
        {_ in
            let email : String = alertController.textFields![0].text ?? ""
            AppDelegate.sharedManagers()?.networkManager.sendForgottenPasswordEmail(emailAddress: email)
        })
    }
    
    
}
