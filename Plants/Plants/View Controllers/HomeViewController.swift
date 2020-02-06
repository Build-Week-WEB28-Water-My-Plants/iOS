//
//  HomeViewController.swift
//  Plants
//
//  Created by Alexander Supe on 01.02.20.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var manageButton: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var happienessLabel: UILabel!
    @IBOutlet weak var wateringDate: UILabel!
    
    // MARK: - Properties
    var profileImage: UIImage?
    static var authenticated: Bool = {
        if UserController.keychain.get("Auth") != nil {
            return true
        } else {
            return false
        }
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        formatViews()
        if !HomeViewController.authenticated { performSegue(withIdentifier: "Login", sender: nil) }
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsButton.isHidden = false
//        let dateFormatter = DateFormatter()
        if let interval = TimeInterval(UserController.keychain.get("Date") ?? "") {
            let date = Date(timeIntervalSince1970: interval)
            wateringDate.text = "Next watering day: \(DateHelper.getRelativeDate(date))"
            if date < Date() {
                //Overdue
                happienessLabel.text = "You plants are thisty"
                happienessLabel.textColor = .systemRed
                wateringDate.text = "Dehydrating since: \(DateHelper.getRelativeDate(date))"
                
            } else {
                //In time
                happienessLabel.text = "All your plants are happy"
                happienessLabel.textColor = .systemGreen
            }
        }
    }
    
    // MARK: - Private Methods
    private func formatViews() {
        //Settings
        if let profileImage = profileImage { settingsButton.setImage(profileImage, for: .normal) }
        else { settingsButton.setImage(UIImage(systemName: "person.crop.circle.fill"), for: .normal) }
        navigationController?.navigationBar.addSubview(settingsButton)
        guard let navigationBar = navigationController?.navigationBar else { return }
        settingsButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -16).isActive = true
        settingsButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -12).isActive = true
        settingsButton.layer.cornerRadius = 20
        
        //FirstView
        firstView.layer.cornerRadius = 10
        
        //SecondView
        secondView.layer.cornerRadius = 10
    }
    
    // MARK: - IBActions
    @IBAction func openNews(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.theguardian.com/lifeandstyle/gardens/")!)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlantsSegue" {
            settingsButton.isHidden = true
        }
    }
    
}
