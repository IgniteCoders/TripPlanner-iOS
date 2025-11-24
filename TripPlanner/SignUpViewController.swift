//
//  SignUpViewController.swift
//  TripPlanner
//
//  Created by Mananas on 20/11/25.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordRepeatTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp(_ sender: Any) {
        let email = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Auth.auth().createUser(withEmail: email, password: password) { [unowned self] authResult, error in
            if let error = error {
                print(error.localizedDescription)
                self.showMessage(message: error.localizedDescription)
                return
            }
            
            print("User created account successfully")
            self.showMessage(title: "Create account", message: "Account created successfully")
        }
    }

}
