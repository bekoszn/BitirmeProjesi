//
//  FavorilerViewModel.swift
//  BitirmeProjesi
//
//  Created by Berke Özgüder on 20.10.2024.
//

import Foundation
import RxSwift
import FirebaseAuth

class FavorilerViewModel {
    
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
        loadFavorites()
    }
    
    func favoriEkle(urun: Urunler) {
        urepo.favoriEkle(urun: urun, userId: userId)
        loadFavorites()
    }

    func favorilerdenKaldir(urun: Urunler) {
        urepo.favorilerdenKaldir(urun: urun, userId: userId)
        loadFavorites()
    }
    
    func loadFavorites() {
        urepo.loadFavorites(userId: userId) { [weak self] favorites in
            self?.favoriListesi.onNext(favorites)
        }
    }

    
}
