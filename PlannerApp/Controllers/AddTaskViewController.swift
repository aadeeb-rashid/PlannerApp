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
class AddTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var descText: UITextView!
    var img: UIImage? = nil
    var long: Float? = nil
    var lat: Float? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return UserData.catList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

            self.view.endEditing(true)
        return UserData.catList[row].name
        }
    
    @IBAction func submitTask(_ sender: UIButton) {
        if(nameText.text == nil || descText.text == nil)
        {
            let alertController = UIAlertController(title: nil, message: "Please fill out all fields", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        }
        else if(picker.numberOfRows(inComponent: 0) == 0)
        {
            let alertController = UIAlertController(title: nil, message: "Please add a Category", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        }
        else
        {
            performSegue(withIdentifier: "taskUnwind", sender: self)
        }
    }
    
    @IBAction func imageGet(_ sender: UIButton) {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        //add new things
        // display image selection view
        
        let alert = UIAlertController(title: "Add Image", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {_ in photoPicker.sourceType = .camera
            self.present(photoPicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Library", style: .default, handler: {_ in photoPicker.sourceType = .photoLibrary
            self.present(photoPicker, animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        picker .dismiss(animated: true, completion: nil)

        img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "taskUnwind")
        {
            if(img != nil)
            {
                    var data = NSData()
                    data = img!.jpegData(compressionQuality: 0.8)! as NSData
                    // set upload path
                let filePath = "\(UserData.userID)/\(nameText.text!)"
                let metaData = StorageMetadata()
                    metaData.contentType = "image/jpg"
                UserData.storage.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                }
                UserData.ref.child("users/\(UserData.userID)/Tasks/\(nameText.text!)/img").setValue(true)
            }
            else{
                UserData.ref.child("users/\(UserData.userID)/Tasks/\(nameText.text!)/img").setValue(false)
            }
            let ind = picker.selectedRow(inComponent: 0)
            UserData.taskList.append(Task(cName: nameText.text!, cDesc: descText.text!, c: UserData.catList[ind], cImg: img, cLong: long, cLat: lat))
            UserData.ref.child("users/\(UserData.userID)/Tasks/\(nameText.text!)/desc").setValue(descText.text!)
            UserData.ref.child("users/\(UserData.userID)/Tasks/\(nameText.text!)/cat").setValue(UserData.catList[ind].name)
            UserData.ref.child("users/\(UserData.userID)/Tasks/\(nameText.text!)/long").setValue(long)
            UserData.ref.child("users/\(UserData.userID)/Tasks/\(nameText.text!)/lat").setValue(lat)
            
        }
        else if(segue.identifier == "mapSegue")
        {
            let locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
            let dest = segue.destination as? MapViewController
            dest?.locationManager = locationManager
        }
    }
    
    @IBAction func unwindToTaskAdd(segue: UIStoryboardSegue)
    {
        picker.reloadAllComponents()
    }
    

}
