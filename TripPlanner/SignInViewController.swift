//
//  ViewController.swift
//  TripPlanner
//
//  Created by Mananas on 20/11/25.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "Navigate To Home", sender: nil)
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        let email = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                self.showMessage(message: error.localizedDescription)
                return
            }
            
            print("User signed in successfully")
            
            self.performSegue(withIdentifier: "Navigate To Home", sender: nil)
        }
    }
}

