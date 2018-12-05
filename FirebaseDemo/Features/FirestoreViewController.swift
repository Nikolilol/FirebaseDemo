//
//  FirestoreViewController.swift
//  FirebaseDemo
//
//  Created by Niko on 12/3/18.
//  Copyright © 2018 Niko. All rights reserved.
//

import UIKit
import FirebaseFirestore

class FirestoreViewController: UIViewController {
    let db = Firestore.firestore()
    @IBOutlet weak var outputTextView: UITextView!
    @IBAction func writeDataAction(_ sender: Any) {
        showActivityIndicator()
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "message": "write a data",
            "name": "niko"
        ]) { err in
            self.hideActivityIndicator()
            if let err = err {
                self.spinnerOnlyText("Error adding document: \(err)")
            } else {
                self.spinnerOnlyText("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    @IBAction func readDataAction(_ sender: Any) {
        showActivityIndicator()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            self.hideActivityIndicator()
            if let err = err {
                self.spinnerOnlyText("Error getting documents: \(err)")
            } else {
                self.spinnerOnlyText("Read documents succeed")
                var strData: String = ""
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    if let theJSONData = try? JSONSerialization.data(
                        withJSONObject: document.data(),
                        options: []) {
                        let theJSONText = String(data: theJSONData,
                                                 encoding: .ascii)
                        strData.append(document.documentID + theJSONText!)
                    }
                }
                self.outputTextView.text = strData
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Realtime Database"
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
