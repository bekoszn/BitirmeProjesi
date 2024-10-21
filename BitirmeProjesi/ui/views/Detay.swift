//
//  Detay.swift
//  BitirmeProjesi
//
//  Created by Berke Özgüder on 12.10.2024.
//

import UIKit
import Kingfisher
import Alamofire
import FirebaseAuth


class Detay: UIViewController {
    
    
    
    
    @IBOutlet weak var imageViewDetay: UIImageView!
    
    @IBOutlet weak var isimLabel: UILabel!
    
    @IBOutlet weak var kargoLabel: UILabel!
    
    @IBOutlet weak var kapiLabel: UILabel!
    @IBOutlet weak var adetLabel: UILabel!
    
    @IBOutlet weak var miktarLabel: UILabel!
    
    @IBOutlet weak var fiyatLabel: UILabel!
    
    @IBOutlet weak var favoriEkleButton: UIButton!
    var urun:Urunler?
    var viewModel = DetayViewModel()
    var sepetListesi = [UrunlerSepeti]()
    var urepo = UrunlerRepository()
    var userId: String {
        return Auth.auth().currentUser?.uid ?? "berke_ozguder"
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let urun = urun {
            
            isimLabel.text = urun.ad
            fiyatLabel.text = String(urun.fiyat!)
            
            if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(urun.resim!)") {
                self.imageViewDetay.kf.setImage(with: url)
            }
            _ = viewModel.sepetListesi.subscribe(onNext: { liste in
                self.sepetListesi = liste
            })
            _ = viewModel.urepo.urunAdet.subscribe(onNext: { adet in
                self.adetLabel.text = String(adet)
            })
            _ = viewModel.urepo.urunToplamFiyat.subscribe(onNext: { urunFiyat in
                self.fiyatLabel.text = String(urunFiyat)
            })
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
    }
    

    
    
    @IBAction func azaltButton(_ sender: Any) {
        viewModel.adetCikar()
        viewModel.urepo.fiyatHesapla(fiyat: Int(exactly: (urun?.fiyat)!)!)
    }
    
    @IBAction func arttırButon(_ sender: Any) {
        viewModel.adetEkle()
        viewModel.urepo.fiyatHesapla(fiyat: Int(exactly: (urun?.fiyat)!)!)
    }
    

    
    @IBAction func sepeteEkleButton(_ sender: Any) {
        if let urun = urun {
            if let ad = isimLabel.text, let resim = urun.resim, let fiyat = fiyatLabel.text, let siparisAdeti = adetLabel.text {
                viewModel.sepeteEkle(urun_ad: ad, urun_resim: resim, urun_kategori: urun.kategori!, urun_fiyat: Int(exactly: urun.fiyat!)!, urun_marka: urun.marka!, siparisAdeti: Int(siparisAdeti)!, kullaniciAdi: userId)
            }
        }
    }
    
    @IBAction func favoriyeEkleButton(_ sender: Any) {
        if let u = urun {
            viewModel.favoriEkle(urun: u)
        }

    }
}
