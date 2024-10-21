//
//  DetayViewModel.swift
//  BitirmeProjesi
//
//  Created by Berke Özgüder on 12.10.2024.
//

import Foundation
import RxSwift
import Alamofire
import FirebaseAuth

class DetayViewModel {
    
    var sepetListesi = BehaviorSubject<[UrunlerSepeti]>(value:[UrunlerSepeti]())
    var favoriListesi = BehaviorSubject<[Urunler]>(value: [Urunler]())
    var urunAdet = BehaviorSubject<Int>(value: 0)
    var urunToplamFiyat = BehaviorSubject<Int>(value: 0)
    private let disposeBag = DisposeBag()
    var urepo = UrunlerRepository()
    var userId: String {
        return Auth.auth().currentUser?.uid ?? "berke_ozguder"
    }

    
    
    init() {
        urepo.favoriListesi
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { favoriler in
                self.favoriListesi.onNext(favoriler)
            }).disposed(by: disposeBag)
        
        urunAdet = urepo.urunAdet
        urunToplamFiyat = urepo.urunToplamFiyat
        
        sepetListesi = urepo.urunlerSepetiListesi
        favoriListesi = urepo.favoriListesi
    }
    
    
    func sepeteEkle(urun_ad:String,urun_resim:String,urun_kategori: String, urun_fiyat:Int,urun_marka:String, siparisAdeti:Int, kullaniciAdi:String){
        urepo.sepeteEkle(ad: urun_ad, resim: urun_resim, kategori: urun_kategori, fiyat: urun_fiyat, marka: urun_marka, siparisAdeti: siparisAdeti, kullaniciAdi: userId)
    }
    
    func adetEkle (){
        urepo.adetEkle()
        
    }
    func adetCikar (){
        urepo.adetCikar()
    }
    
    func favoriEkle(urun: Urunler) {
        urepo.favoriEkle(urun: urun, userId: userId)
    }
    
}
