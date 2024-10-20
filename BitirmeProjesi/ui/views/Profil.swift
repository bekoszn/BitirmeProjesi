//
//  Profil.swift
//  BitirmeProjesi
//
//  Created by Berke Özgüder on 18.10.2024.
//

import UIKit
import Firebase
import FirebaseAuth

class Profil: UIViewController {

    @IBOutlet weak var baslik: UILabel!
    @IBOutlet weak var sifreTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    @IBAction func kayitOlButon(_ sender: Any) {
        if emailTextField.text != "" && sifreTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextField.text!) { authdataresult, error in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata", messageInput: error!.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "toAna", sender: nil)
                }
            }
        } else {
            hataMesaji(titleInput: "Hata!", messageInput: "E-Mail ve Şifre Giriniz")
        }
    }
    
    @IBAction func girisYapButon(_ sender: Any) {
        if emailTextField.text != "" && sifreTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: sifreTextField.text!) { authdataresult, error in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata", messageInput: error!.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "toAna", sender: nil)
                }
            }
        } else {
            hataMesaji(titleInput: "Hata!", messageInput: "E-Mail ve Şifre Giriniz")
        }

    }
    
    
    func hataMesaji(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
        
    }
  
}
