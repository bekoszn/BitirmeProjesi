//
//  ProfilCikis.swift
//  BitirmeProjesi
//
//  Created by Berke Özgüder on 18.10.2024.
//

import UIKit
import Lottie
import FirebaseAuth

class ProfilCikis: UIViewController {

    @IBOutlet weak var animationView: AnimationSubview!
    @IBOutlet weak var profileimageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()



    }
    
    @IBAction func cikisYapButon(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toKayit", sender: nil)
        } catch {
            print("hata")
        }
        
 
        
        
    }
    

}
