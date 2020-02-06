//
//  SettingsTableViewController.swift
//  Plants
//
//  Created by Alexander Supe on 02.02.20.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1.0 : 32
    }
}

class AccountSettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailField: CustomField!
    @IBOutlet weak var phoneField: CustomField!
    @IBOutlet weak var passwordField: CustomField!
    
    // MARK: - Properties
    var email = ""
    var phone = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        emailField.text = email
        phoneField.text = phone
    }
    
    // MARK: - IBActions
    @IBAction func saved(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
