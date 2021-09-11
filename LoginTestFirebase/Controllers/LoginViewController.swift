//
//  LoginViewController.swift
//  LoginTestFirebase
//
//  Created by IwasakIYuta on 2021/09/11.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet private var emailTextField: UITextField!
    
    @IBOutlet private var passwordTextField: UITextField!
    
    @IBOutlet private var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.textContentType = .newPassword
        passwordTextField.isSecureTextEntry = true
        
        loginButton.isEnabled = false
        loginButton.layer.cornerRadius = 10 
        loginButton.backgroundColor = UIColor.rgb(red: 180, green: 255, blue: 221)
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
   
    @IBAction func tapLoginButton(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("ログインに失敗しました",error)
                return
            }
            print("ログインに成功しました")
        }
        
    }
    
    
    @IBAction func tapToRegisterPage(_ sender: UIButton) {
        
        let registerViewController = self.storyboard?.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        navigationController?.pushViewController(registerViewController, animated: true)
        
        
    }
    
    
}

//MRKE: -UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
   
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        if emailIsEmpty || passwordIsEmpty {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 180, green: 255, blue: 221)
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 0, green: 255, blue: 150)
        }
    }
    
    
}
