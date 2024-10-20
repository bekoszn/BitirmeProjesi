//
//  AnasayfaViewModel.swift
//  BitirmeProjesi
//
//  Created by Berke Özgüder on 12.10.2024.
//

import Foundation
import RxSwift

class AnasayfaViewModel {
    var urepo = UrunlerRepository()
    var urunlerListesi = BehaviorSubject<[Urunler]>(value: [Urunler]())

    
    
    init(){
        tumUrunleriGetir()
        urunlerListesi = urepo.urunlerListesi
    }
    
    
    func ara(aramaKelimesi:String){
        urepo.ara(aramaKelimesi: aramaKelimesi)
    }
    
    func tumUrunleriGetir(){
        urepo.tumUrunleriGetir()
    }
    
    func favoriEkle(urun: Urunler) {
        urepo.favoriEkle(urun: urun, userId: "berke_ozguder")
    }

    
    func sepeteEkle(urun: Urunler) {
        
        let urunAdet = 1
        urepo.sepeteEkle(ad: urun.ad!, resim: urun.resim!, kategori: urun.kategori!, fiyat: Int(exactly: urun.fiyat!)!, marka: urun.marka!, siparisAdeti: urunAdet, kullaniciAdi: "berke_ozguder")
    }
    
    
    

}
