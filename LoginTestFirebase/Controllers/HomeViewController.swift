//
//  HomeViewController.swift
//  LoginTestFirebase
//
//  Created by IwasakIYuta on 2021/09/09.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
     var user: User?
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var createdAtLabel: UILabel!
    
    @IBOutlet weak var logout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let user = user else { return  }
        
        nameLabel.text = user.name + "さんようこそ"
        emailLabel.text = user.email
        
        let dateString = dateFormatterForcreatedAt(date: user.createdAt.dateValue())
        
        createdAtLabel.text = "作成日:  " + dateString
        
        
        logout.layer.cornerRadius = 10

    
    }
    //viewがよばれる前によばれるメソッド
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //ログインさ情報がない場合は登録画面に移動する
        conformLoginedUser()
        
    }
    
    private func presentToViewController() {
        //RegisterViewControllerに移動する
        let registerViewController = self.storyboard?.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        registerViewController.modalPresentationStyle = .fullScreen
        let navController = UINavigationController(rootViewController: registerViewController)
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.isHidden = true
        self.present(navController, animated: true, completion: nil)
    
    }
    
    private func conformLoginedUser() {
    //uidとuserがない場合は
        if Auth.auth().currentUser?.uid == nil || user == nil {
            presentToViewController()
        }
    }
    
    
    
    
    @IBAction func logoutButton(_ sender: Any) {
        
        do {
            
            try Auth.auth().signOut()
        
            presentToViewController()
        
        } catch  {
            print(error,"ログアウトに失敗sました")
        }
        
        
        
    
    }
    private func dateFormatterForcreatedAt(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ja_JP")
        
        return dateFormatter.string(from: date)
        
    
    }

    

}
