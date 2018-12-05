//
//  HomeViewController.swift
//  FirebaseDemo
//
//  Created by Niko on 11/30/18.
//  Copyright © 2018 Niko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {

    let welcomeMessageConfigKey = "welcome_message"
    let welcomeMessageCapsConfigKey = "welcome_message_caps"
    let loadingPhraseConfigKey = "loading_phrase"
    
    var remoteConfig: RemoteConfig!
    var tableDataSource: Array<Array<String>> {
        get{
            return [["Realtime Database", "Cloud Firestore", "Storage", "Hosting", "Functions", "ML Kit"],
                    ["Crashlytics", "Performance", "TestLab"],
                    [],
                    ["Predictions", "A/B Testing", "Cloud Messaging", "In-App Messaging", "Remote Config", "Dynamic Links", "AdMob"]]
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBAction func signOutAction(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        self.dismiss(animated: true) {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        
        setupView()
        
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        fetchConfig()
    }
    
    func fetchConfig() {
        welcomeLabel.text = remoteConfig[loadingPhraseConfigKey].stringValue
        
        var expirationDuration = 3600
        // If your app is using developer mode, expirationDuration is set to 0, so each fetch will
        // retrieve values from the service.
        if remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
        
        // [START fetch_config_with_callback]
        // TimeInterval is set to expirationDuration here, indicating the next fetch request will use
        // data fetched from the Remote Config service, rather than cached parameter values, if cached
        // parameter values are more than expirationDuration seconds old. See Best Practices in the
        // README for more information.
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activateFetched()
            } else {
                self.spinnerOnlyText("Error: \(error?.localizedDescription ?? "No error available.")")
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            self.displayWelcome()
        }
        // [END fetch_config_with_callback]
    }
    
    func displayWelcome() {
        // [START get_config_value]
        var welcomeMessage = remoteConfig[welcomeMessageConfigKey].stringValue
        // [END get_config_value]
        
        if remoteConfig[welcomeMessageCapsConfigKey].boolValue {
            welcomeMessage = welcomeMessage?.uppercased()
        }
        welcomeLabel.text = welcomeMessage
    }
    
    func setupData() {

    }
    
    func setupView() {
        // label
        welcomeLabel.text = "Hi Niko Li welcome to Firebase demo!"
        
        print("\(tableDataSource)")
        
        // tableView
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Develop"
        case 1:
            return "Quality"
        case 2:
            return "Analytics"
        case 3:
            return "Grow"
        default:
            return "None"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let subArr = self.tableDataSource[section]
        return subArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")! //1.
        
        let text = self.tableDataSource[indexPath.section][indexPath.row] //2.
        
        cell.textLabel?.text = text //3.
        
        return cell //4.
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let databaseVc = storyBoard.instantiateViewController(withIdentifier: "DatabaseViewController") as UIViewController
            self.navigationController?.pushViewController(databaseVc, animated: true)
        }
        if indexPath.section == 0 && indexPath.row == 1 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let firestoreVc = storyBoard.instantiateViewController(withIdentifier: "FirestoreViewController") as UIViewController
            self.navigationController?.pushViewController(firestoreVc, animated: true)
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let crashVc = storyBoard.instantiateViewController(withIdentifier: "CrashlyticsViewController") as UIViewController
            self.navigationController?.pushViewController(crashVc, animated: true)
        }
        if indexPath.section == 3 && indexPath.row == 4 {
            fetchConfig()
        }
    }
}

