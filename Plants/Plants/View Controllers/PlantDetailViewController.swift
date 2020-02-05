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
    
    var plant: Plant?
    var plantController = PlantController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        locationField.delegate = self
        waterFreqField.delegate = self
        guard let plant = plant else { return }
        nameField.text = plant.nickname
        locationField.text = plant.location
        waterFreqField.text = String(plant.h2oFrequency)
    }
    
    @IBAction func imageButton(_ sender: Any) {
        
    }
    @IBAction func saveButton(_ sender: Any) {
        guard let name = nameField.text, let freq = waterFreqField.text, let loc = locationField.text else {
            //Notify User
            return }
        plantController.createPlantInServer(plant: Plant(speciesId: nil, nickname: name, location: loc, image: Data(), id: Double(Int.random(in: 1...99999)), h2oFrequency: Double(freq), wateredDate: Date())) {
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
