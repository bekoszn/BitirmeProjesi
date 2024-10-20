import UIKit



extension UITabBarController {
    


    
    
    private struct AssociatedKeys {
        static var doubleTapDelegate = "doubleTapDelegate"
    }
    
    var doubleTapDelegate: TabBarDoubleTapDelegate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.doubleTapDelegate) as? TabBarDoubleTapDelegate
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.doubleTapDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // Aynı sekmeye iki kez tıklanıldığında scroll view en üstüne kaydırılacak
    func setupDoubleTapToScrollToTop(for collectionView: UICollectionView) {
        // Tab bar controller'ın delegate'ini ayarlıyoruz
        self.doubleTapDelegate = TabBarDoubleTapDelegate(collectionView: collectionView)
        self.delegate = self.doubleTapDelegate // Hata burada düzeltildi
    }
}

class TabBarDoubleTapDelegate: NSObject, UITabBarControllerDelegate {
    
    weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // Eğer zaten açık olan tab'a tekrar tıklanırsa en üstüne kaydır
        if viewController == tabBarController.selectedViewController {
            collectionView?.setContentOffset(.zero, animated: true)
        }
        return true
    }
}
