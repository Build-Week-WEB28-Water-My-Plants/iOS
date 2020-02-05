//
//  PlantDetailViewController.swift
//  Plants
//
//  Created by Alexander Supe on 01.02.20.
//

import UIKit

class PlantDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameField: CustomField!
    @IBOutlet weak var locationField: CustomField!
    @IBOutlet weak var waterFreqField: CustomField!
    
    var newPlant: NewPlant?
    var newPlantController = NewPlantController.shared
    var creating = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        locationField.delegate = self
        waterFreqField.delegate = self
        if let plant = newPlant {
            nameField.text = plant.nickname
            locationField.text = plant.location
            waterFreqField.text = String(plant.h2oFrequency)
            creating = false
        }
    }
    
    @IBAction func imageButton(_ sender: Any) {
        
    }
    @IBAction func saveButton(_ sender: Any) {
        guard let name = nameField.text, let freq = waterFreqField.text, let loc = locationField.text else {
            //Notify User
            return }
        if creating{
            newPlantController.create(newPlant: NewPlant(nickname: name, id: UUID(), wateredDate: Date(), image: Data(), location: loc, h2oFrequency: Double(freq) ?? 7)) {_ in
            self.navigationController?.popViewController(animated: true)
            }} else {
            newPlantController.update(newPlant!, nickname: name, location: loc, wateredDate: newPlant?.wateredDate, image: imageView?.image?.pngData() ?? Data(), h2oFrequency: Double(freq) ?? 7)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
