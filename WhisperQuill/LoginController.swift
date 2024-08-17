//
//  LoginController.swift
//  WhisperQuill
//
//  Created by Student31 on 17/08/2024.
//

import UIKit

class LoginController: UIViewController {
   
    @IBOutlet weak var login_EDT_email: UITextField!
    
    @IBOutlet weak var login_EDT_password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func submitClicked(_ sender: UIButton) {
    }

    
    @IBAction func openRegisterController(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
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
