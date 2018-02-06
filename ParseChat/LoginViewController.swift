//
//  LoginViewController.swift
//  ParseChat
//
//  Created by Simona Virga on 2/1/18.
//  Copyright © 2018 Simona Virga. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate
{
  
  let userExistsAlert = UIAlertController(title: "Username Exists", message: "This username already exists", preferredStyle: .alert)
  let invalidAlert = UIAlertController(title: "Invalid username or password ", message: "The username or password is invalid. Please try again.", preferredStyle: .alert)
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    setupAlertControllers()
    
    usernameTextField.delegate = self
    passwordTextField.delegate = self
    
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func signUpButton(_ sender: Any)
  {
    registerUser()
  }
  
  
  @IBAction func loginButton(_ sender: Any)
  {
      loginUser()
  }
  
  func registerUser()
  {
    let newUser = PFUser()
    
    newUser.username = usernameTextField.text
    newUser.password = passwordTextField.text
    
    newUser.signUpInBackground { (success: Bool, error: Error?) in
      if let error = error {
        print(error.localizedDescription)
        if String(describing: error.localizedDescription).contains("Account already exists for this username.") {
          print("This user already has an account!!")
          
          self.present(self.userExistsAlert, animated: true) {
          }
        }
        
      } else {
        print("User Registered successfully")
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
      }
    }
  }
    
    
    func loginUser()
    {
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                self.present(self.invalidAlert, animated: true) {
                }
            } else {
                print("User logged in successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
  
  func setupAlertControllers()
  {
    let OKAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
      
    }
    self.userExistsAlert.addAction(OKAction)
    self.invalidAlert.addAction(OKAction)
    
  }
  
  
  
  
  
  
}
