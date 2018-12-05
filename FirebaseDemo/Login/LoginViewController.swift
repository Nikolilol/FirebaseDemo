//
//  LoginViewController.swift
//  FirebaseDemo
//
//  Created by Niko on 11/30/18.
//  Copyright © 2018 Niko. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBAction func forgotPwdAction(_ sender: Any) {
    }
    @IBAction func signInAction(_ sender: Any) {
        guard let email = accountTextField.text, let password = passwordTextField.text else {
            spinnerError("Account & password can not be empty!")
            return
        }
        showActivityIndicator()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // ...
            self.hideActivityIndicator()
            guard error == nil else {
                self.spinnerOnlyText((error?.localizedDescription)!)
                return
            }
            self.spinnerOnlyText("Sign in succeed!")
            
            // go to home
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let homeVc = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as UIViewController
            let navVc = UINavigationController.init(rootViewController: homeVc)
            self.present(navVc, animated: true, completion: {
                
            })
        }
    }
    @IBAction func signUpAction(_ sender: Any) {
        guard let email = accountTextField.text, let password = passwordTextField.text else {
            spinnerError("Account & password can not be empty!")
            return
        }
        showActivityIndicator()
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            // ...
            self.hideActivityIndicator()
            guard error == nil else {
                self.spinnerOnlyText((error?.localizedDescription)!)
                return
            }
            self.spinnerOnlyText("Sign up succeed!")
            
            // go to home
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let homeVc = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as UIViewController
            let navVc = UINavigationController.init(rootViewController: homeVc)
            self.present(navVc, animated: true, completion: {
                
            })
            
        }
    }
    @IBAction func googleSignInAction(_ sender: Any) {
        showActivityIndicator()
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
            print("addStateDidChangeListener: \(auth)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
//        view.backgroundColor = .orange
        // Do any additional setup after loading the view.
    }
    
}
