//
//  ViewController.swift
//  TripPlanner
//
//  Created by Mananas on 20/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

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
        
        Auth.auth().signIn(withEmail: email, password: password) { [unowned self] authResult, error in
            if let error = error {
                print(error.localizedDescription)
                self.showMessage(message: error.localizedDescription)
                return
            }
            
            print("User signed in successfully")
            
            self.performSegue(withIdentifier: "Navigate To Home", sender: nil)
        }
    }
    
    @IBAction func signInWithGoogle(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                showMessage(message: error!.localizedDescription)
                return
            }

            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                showMessage(message: "Unxpected error has occurred.")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { [unowned self] result, error in
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
}

