//
//  PlantsTableViewController.swift
//  Plants
//
//  Created by Alexander Supe on 02.02.20.
//

import UIKit

class PlantsTableViewController: UITableViewController {
    
    var plants: [Plant] = [Plant(speciesId: 1, nickname: "Sunny", location: "Garden", image: Data(), id: 33.0, h2oFrequency: 7)]
     var plantController: PlantController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath) as! PlantsTableViewCell
        let plant = plants[indexPath.row]
        if plant.nickname?.isEmpty ?? true { cell.nameLabel.text = plant.nickname }
        else { cell.nameLabel.text = "\(plant.nickname ?? "") (\(plant.speciesId))" }
        cell.timeLabel.text = "Status: Next Watering tomorrow"
        return cell
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSegue", let destination = segue.destination as? PlantDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
            destination.plant = plants[indexPath.row]
            destination.plantController = plantController
        }
    }
}
