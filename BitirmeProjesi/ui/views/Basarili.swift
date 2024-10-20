//
//  Basarili.swift
//  BitirmeProjesi
//
//  Created by Berke Özgüder on 20.10.2024.
//

import UIKit
import Lottie

class Basarili: UIViewController {
    
    private var animationView : LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView = .init(name: "successanimation")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView!.play()
    }
    

   
}
