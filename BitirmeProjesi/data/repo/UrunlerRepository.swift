//
//  UrunlerRepository.swift
//  BitirmeProjesi
//
//  Created by Berke Özgüder on 12.10.2024.

import Foundation
import RxSwift
import Alamofire
import FirebaseFirestore

class UrunlerRepository {
    var urunlerListesi = BehaviorSubject<[Urunler]>(value: [Urunler]())
    var urunlerSepetiListesi = BehaviorSubject<[UrunlerSepeti]>(value: [UrunlerSepeti]())
    var urunAdet = BehaviorSubject<Int>(value: 0)
    var urunToplamFiyat = BehaviorSubject<Int>(value: 0)
    var favoriListesi = BehaviorSubject<[Urunler]>(value: [Urunler]())
    

    private let db = Firestore.firestore()
    
   
    func favoriEkle(urun: Urunler, userId: String) {
        guard let urunId = urun.id else { return }
        let data: [String: Any] = [
            "id": urunId,
            "ad": urun.ad ?? "",
            "resim": urun.resim ?? "",
            "kategori": urun.kategori ?? "",
            "fiyat": urun.fiyat ?? 0,
            "marka": urun.marka ?? ""
        ]
        db.collection("users").document(userId).collection("favorites").document("\(urunId)").setData(data) { error in
            if let error = error {
                print("Error adding favorite: \(error.localizedDescription)")
            } else {
                print("Favorite added successfully")
            }
        }
    }

 
    func favorilerdenKaldir(urun: Urunler, userId: String) {
        guard let urunId = urun.id else { return }
        db.collection("users").document(userId).collection("favorites").document("\(urunId)").delete() { error in
            if let error = error {
                print("Error removing favorite: \(error.localizedDescription)")
            } else {
                print("Favorite removed successfully")
            }
        }
    }


    func loadFavorites(userId: String, completion: @escaping ([Urunler]) -> Void) {
        db.collection("users").document(userId).collection("favorites").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching favorites: \(error.localizedDescription)")
                completion([])
                return
            }
            
            var favorites = [Urunler]()
            for document in snapshot!.documents {
                let data = document.data()
                let urun = Urunler(
                    id: data["id"] as? Int ?? 0,
                    ad: data["ad"] as? String ?? "",
                    resim: data["resim"] as? String ?? "",
                    kategori: data["kategori"] as? String ?? "",
                    fiyat: data["fiyat"] as? Int ?? 0,
                    marka: data["marka"] as? String ?? ""
                )
                favorites.append(urun)
            }
            completion(favorites)
        }
    }


                                                          
    
    func tumUrunleriGetir(){
        let url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php"
        
        AF.request(url,method: .get).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(UrunlerCevap.self, from: data)
                    if let liste = cevap.urunler {
                        self.urunlerListesi.onNext(liste)//Tetikleme
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func sepeteEkle(ad:String,resim:String, kategori:String,fiyat:Int,marka:String,siparisAdeti:Int,kullaniciAdi:String){
        let url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
        let params:Parameters = ["ad": ad,"resim":resim,"kategori":kategori,"fiyat":fiyat,"marka":marka,"siparisAdeti":siparisAdeti,"kullaniciAdi":kullaniciAdi]
        
        AF.request(url,method: .post,parameters: params).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print("Başarı : \(cevap.success!)")
                    print("Mesaj  : \(cevap.message!)")
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func ara(aramaKelimesi:String){
        let url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php"
        let params:Parameters = ["urun_ad":aramaKelimesi]
        
        AF.request(url,method: .post,parameters: params).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(UrunlerCevap.self, from: data)
                    if let liste = cevap.urunler {
                        self.urunlerListesi.onNext(liste)//Tetikleme
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func sepettekiUrunleriGetir(kullaniciAdi: String, completion: @escaping ([UrunlerSepeti]) -> Void) {
        let url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
        let params:Parameters = ["kullaniciAdi":kullaniciAdi]
        
        AF.request(url,method: .post,parameters: params).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(UrunlerSepetiCevap.self, from: data)
                    if let liste = cevap.urunler_sepeti {
                        self.urunlerSepetiListesi.onNext(liste)//Tetikleme
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func sil(sepetId: String, kullaniciAdi: String, completion: @escaping (Bool) -> Void) {
        let params: Parameters = ["sepetId": sepetId, "kullaniciAdi": kullaniciAdi]
        
        AF.request("http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print("Başarılı : \(cevap.success!)")
                    print("Mesaj : \(cevap.message!)")
                    completion(true) // Başarılıysa completion ile true dön
                } catch {
                    print(error.localizedDescription)
                    completion(false) // Hata varsa false dön
                }
            } else {
                completion(false) // Eğer response'dan veri gelmediyse false dön
            }
        }
    }


    
    func adetEkle() {
            do {
                let currentValue = try urunAdet.value()
                urunAdet.onNext(currentValue + 1)
            } catch {
                print("Error updating urunAdet: \(error.localizedDescription)")
            }
        }
        
        func adetCikar() {
            do {
                let currentValue = try urunAdet.value()
                if currentValue > 1 {
                    urunAdet.onNext(currentValue - 1)
                }
            } catch {
                print("Error updating urunAdet: \(error.localizedDescription)")
            }
        }
        
        func fiyatHesapla(fiyat: Int) {
            do {
                let adet = try urunAdet.value()
                let toplamFiyat = adet * fiyat
                urunToplamFiyat.onNext(toplamFiyat)
            } catch {
                print("Error calculating total price: \(error.localizedDescription)")
            }
        }


    
    
}
