//
//  ViewController.swift
//  WhisperQuill
//
//  Created by Student31 on 17/08/2024.
//

import Foundation
import UIKit

class StartController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func openLoginController(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    @IBAction func openRegisterController(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
    }
}

