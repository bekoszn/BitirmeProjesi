import Foundation
import RxSwift
import Alamofire

class SepetViewModel {
    var urepo = UrunlerRepository()
    var urunlerSepeti = BehaviorSubject<[UrunlerSepeti]>(value: [UrunlerSepeti]())
    var urunAdet = BehaviorSubject<Int>(value: 1)
    var urunToplamFiyat = BehaviorSubject<Int>(value: 0)
    
    init() {
        urunAdet = urepo.urunAdet
        urunToplamFiyat = urepo.urunToplamFiyat
        urunlerSepeti = urepo.urunlerSepetiListesi
    }
    
    func sepettekiUrunleriGetir(kullaniciAdi: String) {
        urepo.sepettekiUrunleriGetir(kullaniciAdi: kullaniciAdi) { urunler in
            // Burada gelen ürünleri grupla
            let groupedUrunler = self.groupUrunler(urunler)
            self.urunlerSepeti.onNext(groupedUrunler)
        }
    }

    func groupUrunler(_ urunler: [UrunlerSepeti]) -> [UrunlerSepeti] {
        var groupedUrunler: [UrunlerSepeti] = []

        for urun in urunler {
            // Ürünün fiyat ve adet değerlerini zorunlu hale getir
            guard let fiyat = urun.fiyat, let adet = urun.siparisAdeti else {
                continue // Eğer biri nil ise, bu ürünü atla
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


    func sil(sepetId: Int, kullaniciAdi: String) {
        urepo.sil(sepetId: String(sepetId), kullaniciAdi: kullaniciAdi) { success in
            if success {
                self.sepettekiUrunleriGetir(kullaniciAdi: kullaniciAdi)
            }
        }
    }
}
