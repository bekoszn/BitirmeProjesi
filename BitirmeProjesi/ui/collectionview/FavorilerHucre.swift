import UIKit


class FavorilerHucre: UICollectionViewCell {
    
    @IBOutlet weak var labelFiyat: UILabel!
    @IBOutlet weak var labelAd: UILabel!
    @IBOutlet weak var imageViewFavoriler: UIImageView!
    @IBOutlet weak var favoriButton: UIButton!
    
    var viewModel: FavorilerViewModel?
    var urun: Urunler?
    var urunlerSepeti : UrunlerSepeti?
    var urepo = UrunlerRepository()
    
    @IBAction func favoriButton(_ sender: Any) {
        guard let urun = urun, let viewModel = viewModel else { return }
        
        let favoriListesi = try! viewModel.favoriListesi.value()
        if let _ = favoriListesi.firstIndex(where: { $0.id == urun.id }) {
            viewModel.favorilerdenKaldir(urun: urun)
        } else {
            viewModel.favoriEkle(urun: urun)
        }
    }
    
    
}
