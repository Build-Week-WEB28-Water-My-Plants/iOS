//
//  PlantDetailViewController.swift
//  Plants
//
//  Created by Alexander Supe on 01.02.20.
//

import UIKit

class PlantDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameField: CustomField!
    @IBOutlet weak var locationField: CustomField!
    @IBOutlet weak var waterFreqField: CustomField!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: CustomButton!
    @IBOutlet weak var deleteButton: CustomButton!
    
    var newPlant: NewPlant?
    var newPlantController = NewPlantController.shared
    var creating = true
    var currentlyEditing = false
    let imagePC = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        locationField.delegate = self
        waterFreqField.delegate = self
        if let plant = newPlant {
            nameField.text = plant.nickname
            locationField.text = plant.location
            waterFreqField.text = String(plant.h2oFrequency)
            if let image = plant.image {
                imageView.image = UIImage(data: image)
            }
            creating = false
        }
        imagePC.delegate = self
        currentlyEditing = false
        imageButton.isHidden = true
        if creating {
            createMode()
        } else {
            viewMode()
        }
    }
    
    func createMode() {
        editMode()
        deleteButton.isHidden = true
    }
    
    func editMode() {
        editButton.isEnabled = false
        editButton.tintColor = .clear
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        imageButton.isHidden = false
        deleteButton.isHidden = false
    }
    
    func viewMode() {
        editButton.isEnabled = true
        editButton.tintColor = .systemBlue
        saveButton.setTitle("Watered", for: .normal)
        saveButton.backgroundColor = .systemGreen
    }
    
    @IBAction func edit(_ sender: Any) {
        currentlyEditing = true
        editMode()
    }
    

    @IBAction func deletePressed(_ sender: Any) {
        if let newPlant = newPlant {
            newPlantController.delete(newPlant)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func imageButton(_ sender: Any) {
        imagePC.allowsEditing = false
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default , handler: { (sction: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePC.sourceType = .camera
                self.present(self.imagePC, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Libary", style: .default , handler: { (sction: UIAlertAction) in
            self.imagePC.sourceType = .photoLibrary
            self.present(self.imagePC, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        imageView.image = image
        dismiss(animated: true, completion: nil)
        imageButton.isHidden = true
    }
    
    
    
    
    
    @IBAction func saveButton(_ sender: Any) {
        if currentlyEditing || creating {
            
            save()
        } else {
            resetTimer()
        }
    }
    
    func resetTimer() {
        newPlantController.update(newPlant!, nickname: newPlant?.nickname, location: newPlant?.location, wateredDate: Date(), image: newPlant?.image, h2oFrequency: newPlant?.h2oFrequency ?? 7)
    }
    
    
    func save() {
        guard let name = nameField.text, let freq = waterFreqField.text, let loc = locationField.text, !name.isEmpty, !freq.isEmpty, !loc.isEmpty else {
            //Notify User
            return }
        currentlyEditing = false
        viewMode()
        if creating{
            newPlantController.create(newPlant: NewPlant(nickname: name, id: UUID(), wateredDate: Date(), image: Data(), location: loc, h2oFrequency: Double(freq) ?? 7)) {_ in
                self.navigationController?.popViewController(animated: true)
            }} else {
            newPlantController.update(newPlant!, nickname: name, location: loc, wateredDate: newPlant?.wateredDate, image: imageView?.image?.pngData() ?? Data(), h2oFrequency: Double(freq) ?? 7)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if currentlyEditing || creating {
            return true
        } else { return false }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
