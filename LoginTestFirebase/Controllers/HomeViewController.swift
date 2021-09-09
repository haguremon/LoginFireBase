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
    
    @IBAction func logoutButton(_ sender: Any) {
        
        do {
            
            try Auth.auth().signOut()
        
            dismiss(animated: true, completion: nil)
        
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
