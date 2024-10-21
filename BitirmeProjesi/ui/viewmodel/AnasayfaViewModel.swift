//
//  AnasayfaViewModel.swift
//  BitirmeProjesi
//
//  Created by Berke Özgüder on 12.10.2024.
//

import Foundation
import RxSwift
import FirebaseAuth

class AnasayfaViewModel {
    var urepo = UrunlerRepository()
    var urunlerListesi = BehaviorSubject<[Urunler]>(value: [Urunler]())
    var userId: String {
        return Auth.auth().currentUser?.uid ?? "berke_ozguder"
    }

    
    
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
        urepo.favoriEkle(urun: urun, userId: userId)
    }

    
    func sepeteEkle(urun: Urunler) {
        
        let urunAdet = 1
        urepo.sepeteEkle(ad: urun.ad!, resim: urun.resim!, kategori: urun.kategori!, fiyat: Int(exactly: urun.fiyat!)!, marka: urun.marka!, siparisAdeti: urunAdet, kullaniciAdi: userId)
    }
    
    
    

}
