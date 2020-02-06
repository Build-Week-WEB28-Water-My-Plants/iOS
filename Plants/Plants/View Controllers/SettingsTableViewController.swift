//
//  SettingsTableViewController.swift
//  Plants
//
//  Created by Alexander Supe on 02.02.20.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1.0 : 32
    }
}

class AccountSettingsViewController: UIViewController {
    
    @IBOutlet weak var emailField: CustomField!
    @IBOutlet weak var phoneField: CustomField!
    @IBOutlet weak var passwordField: CustomField!
    
    var email = ""
    var phone = ""
    
    override func viewDidLoad() {
        emailField.text = email
        phoneField.text = phone
    }
    
    @IBAction func saved(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
