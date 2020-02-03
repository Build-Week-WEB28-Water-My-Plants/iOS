//
//  HomeViewController.swift
//  Plants
//
//  Created by Alexander Supe on 01.02.20.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var manageButton: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var statusText: UILabel!
    
    var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsButton.isHidden = false
    }
    
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
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlantsSegue" {
            settingsButton.isHidden = true
        }
     }
    
}
