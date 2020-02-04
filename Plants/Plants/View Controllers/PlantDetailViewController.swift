//
//  PlantDetailViewController.swift
//  Plants
//
//  Created by Alexander Supe on 01.02.20.
//

import UIKit

class PlantDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameField: CustomField!
    @IBOutlet weak var speciesField: CustomField!
    @IBOutlet weak var locationField: CustomField!
    @IBOutlet weak var waterFreqField: CustomField!
    
    var plant: Plant?
    var plantController: PlantController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let plant = plant else { return }
        nameField.text = plant.nickname
        //speciesField.text = plant.species
        locationField.text = plant.location
        waterFreqField.text = String(plant.h2oFrequency)
    }
    
    @IBAction func imageButton(_ sender: Any) {
        
    }
    @IBAction func saveButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}
