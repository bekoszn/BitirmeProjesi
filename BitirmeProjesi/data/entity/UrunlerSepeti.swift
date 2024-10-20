//
//  UrunlerSepeti.swift
//  BitirmeProjesi
//
//  Created by Berke Özgüder on 13.10.2024.
//

import Foundation

class UrunlerSepeti: Codable {
    var sepetId : Int?
    var ad : String?
    var resim : String?
    var kategori : String?
    var fiyat : Int?
    var marka : String?
    var siparisAdeti: Int?
    var kullaniciAdi : String?
    var toplamFiyat : Int?
    
    init() {
        
    }
    
    
    
    init(sepetId: Int, ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String, toplamFiyat: Int) {
        self.sepetId = sepetId
        self.ad = ad
        self.resim = resim
        self.kategori = kategori
        self.fiyat = fiyat
        self.marka = marka
        self.siparisAdeti = siparisAdeti
        self.kullaniciAdi = kullaniciAdi
        self.toplamFiyat = toplamFiyat
    }
    

}
