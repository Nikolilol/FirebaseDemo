//
//  DatabaseViewController.swift
//  FirebaseDemo
//
//  Created by Niko on 12/3/18.
//  Copyright © 2018 Niko. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DatabaseViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBAction func writeDataAction(_ sender: Any) {
        guard let inputStr = inputTextField.text else {
            return
        }
        
        self.ref.child("/usagedemo-7594d/message").setValue(inputStr)
        self.inputTextField.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Realtime Database"
        
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        
        ref.child("usagedemo-7594d").child("message").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
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
