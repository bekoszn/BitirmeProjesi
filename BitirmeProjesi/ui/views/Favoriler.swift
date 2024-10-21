
import UIKit
import Kingfisher
import FirebaseFirestore
import RxSwift

class Favoriler: UIViewController {
    @IBOutlet weak var labelBaslik: UILabel!
    @IBOutlet weak var favorilerCollectionView: UICollectionView!
    var favoriListesi = [Urunler]()
    var viewModel = FavorilerViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favorilerCollectionView.delegate = self
        favorilerCollectionView.dataSource = self
        
        // Firebase'den favorileri yükle
        viewModel.favoriListesi
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { favoriler in
                self.favoriListesi = favoriler
                self.favorilerCollectionView.reloadData()
            }).disposed(by: disposeBag)


        viewModel.loadFavorites()
        
 
        let tasarim = UICollectionViewFlowLayout()
        tasarim.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tasarim.minimumInteritemSpacing = 10
        tasarim.minimumLineSpacing = 10
        
        let ekranGenislik = UIScreen.main.bounds.width
        let itemGenislik = (ekranGenislik - 30) / 2
        
        tasarim.itemSize = CGSize(width: itemGenislik, height: itemGenislik * 1.2)
        favorilerCollectionView.collectionViewLayout = tasarim
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        viewModel.loadFavorites()
    }
}

extension Favoriler: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriListesi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favori = favoriListesi[indexPath.row]
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: "favorilerHucre", for: indexPath) as! FavorilerHucre
        
 
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(favori.resim!)") {
            hucre.imageViewFavoriler.kf.setImage(with: url)
        }
        
        hucre.labelAd.text = favori.ad
        hucre.labelFiyat.text = "\(favori.fiyat!) ₺"

        hucre.layer.borderWidth = 0.3
        hucre.layer.cornerRadius = 10.0
        
        hucre.urun = favori
        hucre.viewModel = viewModel
        
        // Favori butonunun durumu
        let favoriListesi = try! viewModel.favoriListesi.value()
        if favoriListesi.contains(where: { $0.id == favori.id }) {
            hucre.favoriButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            hucre.favoriButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }

        return hucre
    }
}
