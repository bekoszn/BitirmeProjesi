//
//  Sepet.swift
//  BitirmeProjesi
//
//  Created by Berke Özgüder on 12.10.2024.
//


import UIKit
import FirebaseAuth


class Sepet : UIViewController {
    
    @IBOutlet weak var labelBaslik: UILabel!
    @IBOutlet weak var sepetTableView: UITableView!
    @IBOutlet weak var labelSepetToplam: UILabel!
    var viewModel = SepetViewModel()
    var userId: String {
        return Auth.auth().currentUser?.uid ?? "berke_ozguder"
    }

    
    var sepetListesi = [UrunlerSepeti]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sepetTableView.delegate = self
        sepetTableView.dataSource = self
        
        viewModel.sepettekiUrunleriGetir(kullaniciAdi: userId)

        _ = viewModel.urunlerSepeti.subscribe(onNext: { liste in
            self.sepetListesi = self.groupUrunler(liste) // Ürünleri grupla
            DispatchQueue.main.async {
                self.sepetTableView.reloadData()
                self.updateSepetToplam()
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.sepettekiUrunleriGetir(kullaniciAdi: userId)
    }

    
    @IBAction func buttonSepetOnayla(_ sender: Any) {
        performSegue(withIdentifier: "toBasarili", sender: nil)
 
    }
    
    func updateSepetToplam() {
        let toplam = sepetListesi.reduce(0) { (result, sepet) -> Int in
            if let urunFiyat = sepet.fiyat, let urunAdet = sepet.siparisAdeti {
                return result + (urunFiyat * urunAdet)
            }
            return result
        }
        labelSepetToplam.text = "\(toplam) ₺"
    }
    
    func groupUrunler(_ urunler: [UrunlerSepeti]) -> [UrunlerSepeti] {
        var groupedUrunler: [UrunlerSepeti] = []

        for urun in urunler {
            guard let fiyat = urun.fiyat, let adet = urun.siparisAdeti else {
                continue // Eğer fiyat veya adet nil ise atla
            }

            // Aynı ürün var mı kontrol et
            if let index = groupedUrunler.firstIndex(where: { $0.ad == urun.ad }) {
                // Aynı ürün bulunursa, adetini artır
                groupedUrunler[index].siparisAdeti = (groupedUrunler[index].siparisAdeti ?? 0) + adet
            } else {
                // Yeni ürünü ekle
                groupedUrunler.append(urun)
            }
        }

        return groupedUrunler
    }

}


extension Sepet : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sepetListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sepet = sepetListesi[indexPath.row]
        
        let hucre = tableView.dequeueReusableCell(withIdentifier: "sepetHucre") as! SepetHucre
        
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(sepet.resim!)"){
                    DispatchQueue.main.async {
                        hucre.imageViewSepet.kf.setImage(with: url)
                    }
                }
        
        hucre.labelAd.text = sepet.ad
        hucre.labelAdet.text = "Toplam: \(sepet.siparisAdeti!)"
        hucre.labelFiyat.text = "\(sepet.fiyat!) ₺"

        
        if let urunFiyat = sepet.fiyat, let urunAdet = sepet.siparisAdeti {
            let result = urunFiyat * urunAdet
            hucre.labelToplamFiyat.text = "\(result) ₺"
                } else {
                    print("Fiyat veya adet değerleri uygun formatta değil.")
                }
        



        hucre.layer.borderWidth = 2


        
        hucre.sepet = self
        hucre.urunlerSepeti = sepet
        
        return hucre
    }
    
    
}
