//
//  ViewController.swift
//  BitirmeProjesi
//
//  Created by Berke Özgüder on 6.10.2024.
//

import UIKit
import Kingfisher
import RxSwift

class AnaSayfa: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var anaCollectionView: UICollectionView!
    
    var urunlerListesi = [Urunler]()
    private let disposeBag = DisposeBag()
    var viewModel = AnasayfaViewModel()
    var isAscending = true
    

    let images: [UIImage] = [
        UIImage(named: "1.png")!,
        UIImage(named: "2.png")!,
        UIImage(named: "3.png")!
    ]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anaCollectionView.delegate = self
        anaCollectionView.dataSource = self
        
        
        _ = viewModel.urunlerListesi.subscribe(onNext: { liste in
            self.urunlerListesi = liste
            self.anaCollectionView.reloadData()
            
            
        })
        
        searchBar.delegate = self
        tabBarController?.setupDoubleTapToScrollToTop(for: anaCollectionView)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Lexend Deca", size: 20) ?? UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.black // İsteğe bağlı: Renk ayarlama
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attributes
        


        
        let tasarim = UICollectionViewFlowLayout()
        tasarim.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tasarim.minimumInteritemSpacing = 10
        tasarim.minimumLineSpacing = 10
        
        let ekranGenislik = UIScreen.main.bounds.width
        let itemGenislik = (ekranGenislik - 30) / 2
        tasarim.itemSize = CGSize(width: itemGenislik, height: itemGenislik*1.495)
        
        anaCollectionView.collectionViewLayout = tasarim
    }
}
    
    




extension AnaSayfa: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urunlerListesi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let urun = urunlerListesi[indexPath.row]
        
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: "urunlerHucre", for: indexPath) as! UrunlerHucre

        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(urun.resim!)") {
            DispatchQueue.main.async {
                hucre.imageView.kf.setImage(with: url)
            }
        }
        
        // Eski zamanlayıcıyı iptal et
        hucre.timer?.invalidate()
        hucre.timer = nil


        startBannerAnimation(in: hucre.bannerView, hucre: hucre)
        
        
        func startBannerAnimation(in bannerView: UIImageView, hucre: UrunlerHucre) {
            var currentIndex = 0
            let totalImages = self.images.count
            
            // Yeni bir zamanlayıcı başlatmadan önce, eskiyi iptal ettiğimizden emin oluyoruz
            hucre.timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
                currentIndex = (currentIndex + 1) % totalImages
                let nextImage = self.images[currentIndex]
                
                // Yavaşça fade-out ve fade-in geçişi sağlamak için
                UIView.animate(withDuration: 1.0, animations: {
                    bannerView.alpha = 0.0
                }, completion: { _ in
                    // Resim değiştirildiğinde tekrar fade-in yapıyoruz
                    bannerView.image = nextImage
                    UIView.animate(withDuration: 1.0) {
                        bannerView.alpha = 1.0
                    }
                })
            }
        }
        

        hucre.imageView.frame.size = CGSize(width: 180, height: 80)
        hucre.imageView.contentMode = .scaleAspectFit
    
        
        hucre.urunLabel.text = urun.ad!
        hucre.fiyatLabel.text = "\(urun.fiyat!) ₺"
        

        
        hucre.layer.borderColor = UIColor.lightGray.cgColor
        hucre.layer.borderWidth = 0.5
        hucre.layer.cornerRadius = 10.0
        
        hucre.urun = urun
        hucre.viewModel = viewModel
        
        return hucre
    }
    
    
    @IBAction func siralaButon(_ sender: Any) {
        print("sırala butonu çalıştı")
        

        if isAscending {
            urunlerListesi.sort { $0.fiyat! < $1.fiyat! }
        } else {
            urunlerListesi.sort { $0.fiyat! > $1.fiyat! }
        }
        

        isAscending.toggle()
        

        anaCollectionView.reloadData()

    
    }
    
    @IBAction func teknolojiButon(_ sender: Any) {
        print("teknoloji butonu çalıştı")
        _ = viewModel.urunlerListesi.subscribe(onNext: { liste in
            self.urunlerListesi = liste.filter { $0.kategori == "Teknoloji" }
            

            
            self.anaCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }
    @IBAction func aksesuarButon(_ sender: Any) {
        print("aksesuar butonu çalıştı")
        

        _ = viewModel.urunlerListesi.subscribe(onNext: { liste in
            self.urunlerListesi = liste.filter { $0.kategori == "Aksesuar" }

            
            self.anaCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }
    @IBAction func kozmetikButon(_ sender: Any) {
        print("kozmetik butonu çalıştı")
        
        _ = viewModel.urunlerListesi.subscribe(onNext: { liste in
            self.urunlerListesi = liste.filter { $0.kategori == "Kozmetik" }
            

            
            self.anaCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }



    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urun = urunlerListesi[indexPath.row]
        performSegue(withIdentifier: "toDetay", sender: urun)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            if let urun = sender as? Urunler {
                let gidilecekVC = segue.destination as! Detay
                gidilecekVC.urun = urun
            }
        }
    }
}

extension AnaSayfa : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange aramaKelimesi: String) {
        if aramaKelimesi.isEmpty {
            _ = viewModel.urunlerListesi.subscribe(onNext: { liste in
                self.urunlerListesi = liste
                self.anaCollectionView.reloadData()
            }).disposed(by: disposeBag)
        } else {
            _ = viewModel.urunlerListesi.subscribe(onNext: { liste in
                self.urunlerListesi = liste.filter { $0.ad!.lowercased().contains(aramaKelimesi.lowercased()) }
                self.anaCollectionView.reloadData()
            }).disposed(by: disposeBag)
        }
    }
}
