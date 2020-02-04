//
//  LoginViewController.swift
//  Plants
//
//  Created by Alexander Supe on 03.02.20.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var username: CustomField!
    @IBOutlet weak var password: CustomField!
    @IBOutlet weak var phoneNumber: CustomField!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var continueButton: CustomButton!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
        phoneNumber.delegate = self
        continueButton.titleLabel?.leadingAnchor.constraint(equalTo: continueButton.leadingAnchor, constant: 20).isActive = true
        continueButton.titleLabel?.trailingAnchor.constraint(equalTo: continueButton.trailingAnchor, constant: -20).isActive = true
        continueButton.titleLabel?.textAlignment = .center
    }
    
    @IBAction func login(_ sender: Any) {
        if segment.selectedSegmentIndex == 0 {
            guard let username = username.text, let password = password.text else { return }
            UserController.shared.signUp(with: UserRepresentation(username: username, password: password)) { (error) in
                DispatchQueue.main.async {
                    if !self.isError(error) {
                        DispatchQueue.main.async {
                            HomeViewController.authenticated = true
                            self.performSegue(withIdentifier: "FinishSegue", sender: nil)
                        }
                    }
                }
            }
        } else {
            guard let username = username.text, let password = password.text, let phoneNumber = phoneNumber.text else { return }
            UserController.shared.signUp(with: UserRepresentation(username: username, password: password, phoneNumber: phoneNumber)) { (error) in
                DispatchQueue.main.async {
                    if !self.isError(error) {
                        HomeViewController.authenticated = true
                        self.performSegue(withIdentifier: "FinishSegue", sender: nil)
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    @IBAction func ckLogin(_ sender: Any) {
        
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        if segment.selectedSegmentIndex == 0 {
            titleLabel.text = "Login"
            phoneNumber.isHidden = true
            continueButton.titleLabel?.text = "Login"
        } else {
            titleLabel.text = "Sign Up"
            phoneNumber.isHidden = false
            continueButton.titleLabel?.text = "Sign Up"
        }
    }
    
    
    
    private func isError(_ error: Error?) -> Bool {
        if error != nil {
            print(error.debugDescription)
            let popup = UIAlertController(title: "An error occured", message: "Please try again later", preferredStyle: .alert)
            popup.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            self.present(popup, animated: true)
            return true
        }
        return false
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
