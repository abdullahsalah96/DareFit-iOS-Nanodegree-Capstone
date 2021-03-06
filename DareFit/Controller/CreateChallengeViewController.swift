//
//  CreateChallengeViewController.swift
//  DareFit
//
//  Created by Abdalla Elshikh on 4/29/20.
//  Copyright © 2020 Abdalla Elshikh. All rights reserved.
//

import UIKit


class CreateChallengeViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var swimmingCardImageView: UIImageView!
    @IBOutlet weak var cyclingCardImageView: UIImageView!
    @IBOutlet weak var runningCardImageView: UIImageView!
    //variables
    var challenge = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureImageViews(){
        //configuring image views
        runningCardImageView.isUserInteractionEnabled = true
        cyclingCardImageView.isUserInteractionEnabled = true
        swimmingCardImageView.isUserInteractionEnabled = true
        let runningTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(runningImageViewClicked))
        runningCardImageView.addGestureRecognizer(runningTapRecognizer)
        let swimmingTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(swimmingImageViewClicked))
        swimmingCardImageView.addGestureRecognizer(swimmingTapRecognizer)
        let cyclingTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cyclingImageViewClicked))
        cyclingCardImageView.addGestureRecognizer(cyclingTapRecognizer)
    }

    @objc func runningImageViewClicked(recognizer: UITapGestureRecognizer){
        challenge = Constants.challenges.running
        performSegue(withIdentifier: Constants.SegueIDs.challengeDetails, sender: nil)
    }
    @objc func cyclingImageViewClicked(recognizer: UITapGestureRecognizer){
        challenge = Constants.challenges.cycling
        performSegue(withIdentifier: Constants.SegueIDs.challengeDetails, sender: nil)
    }
    @objc func swimmingImageViewClicked(recognizer: UITapGestureRecognizer){
        challenge = Constants.challenges.swimming
        performSegue(withIdentifier: Constants.SegueIDs.challengeDetails, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIDs.challengeDetails{
            let vc = segue.destination as! CreateChallengeDetailsViewController
            vc.challenge = challenge
        }
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        signOut()
    }
    
    
    func signOut(){
        Authentication.signOut { (error) in
            guard error == nil else{
                self.showAlert(title: "Error", message: "Can't logout at the moment")
                return
            }
            //logout
            self.navigationController?.popToRootViewController(animated: true)
            self.resetUserData()
        }
    }
    
    func resetUserData(){
        //resetting user data after signing out
        CurrentUser.currentUser.firstName = ""
        CurrentUser.currentUser.lastName = ""
        CurrentUser.currentUser.uid = ""
        CurrentUser.currentUser.latitude = 0
        CurrentUser.currentUser.longitude = 0
    }
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertVC, animated: true)
    }
}
