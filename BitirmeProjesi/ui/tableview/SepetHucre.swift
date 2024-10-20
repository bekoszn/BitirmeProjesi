//
//  SepetHucre.swift
//  BitirmeProjesi
//
//  Created by Berke Özgüder on 15.10.2024.
//

import UIKit

class SepetHucre: UITableViewCell {


    @IBOutlet weak var imageViewSepet: UIImageView!
    @IBOutlet weak var labelAd: UILabel!
    @IBOutlet weak var labelAdet: UILabel!
    @IBOutlet weak var labelFiyat: UILabel!
    @IBOutlet weak var labelToplamFiyat: UILabel!
    
    var sepet: Sepet?
    var urunlerSepeti: UrunlerSepeti?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    @IBAction func buttonSil(_ sender: Any) {
        if let urunlerSepeti = urunlerSepeti {
            // Önce sepetten ürünü sil
            sepet?.viewModel.sil(sepetId: urunlerSepeti.sepetId!, kullaniciAdi: "berke_ozguder")
            
            // Silme işlemi sonrası hemen ürünü listeden çıkar
            if let index = sepet?.sepetListesi.firstIndex(where: { $0.sepetId == urunlerSepeti.sepetId }) {
                sepet?.sepetListesi.remove(at: index) // Ürünü listeden çıkar
                sepet?.sepetTableView.reloadData()   // Tabloyu güncelle
                sepet?.updateSepetToplam()           // Sepet toplamını güncelle
            }
        }
    }


}
