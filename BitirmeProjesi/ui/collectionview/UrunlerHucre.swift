//
//  UrunlerHucre.swift
//  BitirmeProjesi
//
//  Created by Berke Özgüder on 12.10.2024.
//

import UIKit


class UrunlerHucre: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var urunLabel: UILabel!
    @IBOutlet weak var fiyatLabel: UILabel!
    @IBOutlet weak var bannerView: UIImageView!
    
    var urun: Urunler?
    var urunlerSepeti : UrunlerSepeti?
    var viewModel: AnasayfaViewModel?
    var urepo = UrunlerRepository()
    var timer: Timer?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Zamanlayıcıyı iptal et
        timer?.invalidate()
        timer = nil
    }
    
    
    @IBAction func sepetButton(_ sender: Any) {
        guard let urun = urun else { return }
        viewModel?.sepeteEkle(urun: urun)
        print("\(urun.ad!) sepete eklendi")
    }
    
    @IBAction func favoriButtton(_ sender: Any) {
        guard let urun = urun else { return }
        viewModel?.favoriEkle(urun: urun)
        
        // Butonun simgesini değiştirin
        if let button = sender as? UIButton {
            if button.currentImage == UIImage(systemName: "heart") {
                button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                button.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
        
        
        
        
        
    }
}
