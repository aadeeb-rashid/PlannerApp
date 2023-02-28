//
//  AddTaskViewController.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 4/22/22.
//

import UIKit
import CoreLocation
import FirebaseStorage
import FirebaseDatabase
class AddTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var descText: UITextView!
    var img: UIImage? = nil
    override func viewDidLoad()
    {
        AppDelegate.sharedManagers()?.errorManager.setDelegate(viewController: self)
        super.viewDidLoad()
    }
    
    
    @IBAction func submitTask(_ sender: UIButton)
    {
        if(nameText.text == nil || descText.text == nil)
        {
            AppDelegate.sharedManagers()?.errorManager.handleError(error: CreateError.FillOutAllFields)
            return
        }
        if(picker.numberOfRows(inComponent: 0) == 0)
        {
            AppDelegate.sharedManagers()?.errorManager.handleError(error: CreateError.NoCategory)
            return
        }
        self.performSegue(withIdentifier: "taskUnwind", sender: self)
    }
    
    @IBAction func imageGet(_ sender: UIButton)
    {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        self.showAlertFromPhotoPicker(photoPicker: photoPicker)
    }
    
    private func showAlertFromPhotoPicker(photoPicker : UIImagePickerController)
    {
        let alert = UIAlertController(title: "Add Image", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {_ in photoPicker.sourceType = .camera
            self.present(photoPicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Library", style: .default, handler: {_ in photoPicker.sourceType = .photoLibrary
            self.present(photoPicker, animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker .dismiss(animated: true, completion: nil)
        img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "taskUnwind")
        {
            AppDelegate.sharedManagers()?.networkManager.addTaskToDatabase(img: img, taskName: nameText.text ?? "", taskDescription: descText.text ?? "", categoryIndex: picker.selectedRow(inComponent: 0))
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return AppDelegate.sharedManagers()?.userManager.getCategories().count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        self.view.endEditing(true)
        return AppDelegate.sharedManagers()?.userManager.getCategories()[row].name
    }
    
    @IBAction func unwindToTaskAdd(segue: UIStoryboardSegue)
    {
        picker.reloadAllComponents()
    }
    

}
