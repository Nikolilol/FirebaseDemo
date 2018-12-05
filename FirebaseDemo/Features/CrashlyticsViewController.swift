//
//  CrashlyticsViewController.swift
//  FirebaseDemo
//
//  Created by Niko on 12/3/18.
//  Copyright © 2018 Niko. All rights reserved.
//

import UIKit
import Crashlytics

class CrashlyticsViewController: UIViewController {

    @IBAction func indexCrashAction(_ sender: Any) {
        let array: Array = ["1", "2"]
        let str = array[3]
        print("\(str)")
    }
    @IBAction func crashAction(_ sender: Any) {
    Crashlytics.sharedInstance().crash()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
