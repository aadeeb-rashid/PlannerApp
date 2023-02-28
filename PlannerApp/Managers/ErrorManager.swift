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
    
    func handlePotentialError(error: Error?, completionHandler: @escaping ([Category], [Task]) -> Void)
    {
        if let error = error
        {
            self.handleError(error: error)
            completionHandler([], [])
        }
    }
    
    func handleError(error: Error)
    {
        DispatchQueue.main.async
        {
            let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in
            }))
            self.delegate!.present(alertController, animated: true)
        }
    }
    
}
