//
//  ViewController.swift
//  LoginTestFirebase
//
//  Created by IwasakIYuta on 2021/09/08.

import UIKit
import Firebase
import PKHUD

class ViewController: UIViewController {
    
    
    @IBOutlet private var emailTextField: UITextField!
    
    @IBOutlet private var passwordTextField: UITextField!
    
    @IBOutlet private var userNameTextField: UITextField!
    
    @IBOutlet private var registerButton: UIButton!
    
    @IBAction func tappedRegisterButton(_ sender: Any) {
        handleAuthToFirebase()
    }
    
    private func handleAuthToFirebase(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { [ weak self ] (result, error) in
            if let error = error {
                print("認証情報の保存に失敗しました。\(error)")
                return
            }
            self?.addUserInfoToFirestore(email: email)
        }
    }
    private func addUserInfoToFirestore(email: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let name = self.userNameTextField.text else { return }
        let documentData = ["email": email, "name": name, "createdAt": Timestamp()] as [String : Any]
        let usersRef = Firestore.firestore().collection("users").document(uid)
        usersRef.setData(documentData) { (error) in
            if let error = error {
                print("認証情報の保存に失敗しました\(error)")
                return
            }
            print("認証情報の保存に成功しました。")
            usersRef.getDocument { (snapshot, error) in
                if let error = error {
                    print("ユーザー情報の取得に失敗しました。\(error)")
                    return
                }
                guard let date = snapshot?.data() else { return }
                let user = User.init(dic: date)
                print("ユーザー情報の取得に成功しました.\(user)")
                let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                homeViewController.user = user
                homeViewController.modalPresentationStyle = .fullScreen                
                
                self.present(homeViewController, animated: true, completion: nil)
                
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.textContentType = .newPassword
        passwordTextField.isSecureTextEntry = true

        
        registerButton.isEnabled = false
        registerButton.layer.cornerRadius = 10 //角を丸く
        registerButton.backgroundColor = UIColor.rgb(red: 180, green: 255, blue: 221)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        //キーボードの認識
        NotificationCenter.default.addObserver(self, selector: #selector(showkeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidekeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func showkeyboard(notification: Notification){
        //キーボードのフレームを求める
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        //https://qiita.com/st43/items/3802624d15a8dded8169 //フレームについて
        guard let kayboardMinY = keyboardFrame?.minY else { return } //キーボードの高さ
        let registerButtonMaxY = registerButton.frame.maxY //registerButtonの底辺の位置
        let distance = registerButtonMaxY - kayboardMinY + 30
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        //https://qiita.com/hachinobu/items/57d4c305c907805b4a53 //Animation
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.view.transform = transform
        })
        //print("kayboardMinY: \(String(describing: kayboardMinY)), registerButtonMaxY: \(registerButtonMaxY)")
    }
    @objc func hidekeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.view.transform = .identity
        })
    }
    //画面をタップした時にキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
extension ViewController: UITextFieldDelegate { //可読性の向上ｗ
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let usernameIsEmpty = userNameTextField.text?.isEmpty ?? true
        if emailIsEmpty || passwordIsEmpty || usernameIsEmpty {
            registerButton.isEnabled = false
            registerButton.backgroundColor = UIColor.rgb(red: 180, green: 255, blue: 221)
        } else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = UIColor.rgb(red: 0, green: 255, blue: 150)
        }
    }
    
    
}
