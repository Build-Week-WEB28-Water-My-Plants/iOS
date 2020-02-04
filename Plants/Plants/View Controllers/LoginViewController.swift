//
//  LoginViewController.swift
//  Plants
//
//  Created by Alexander Supe on 03.02.20.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: AuthField!
    @IBOutlet weak var password: AuthField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: Any) {
        HomeViewController.authenticated = true
    }
    @IBAction func signUp(_ sender: Any) {
        HomeViewController.authenticated = true
    }
    @IBAction func ckLogin(_ sender: Any) {
        HomeViewController.authenticated = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
