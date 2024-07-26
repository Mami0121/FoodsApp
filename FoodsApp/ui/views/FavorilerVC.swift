//
//  FavorilerVC.swift
//  FoodsApp
//
//  Created by Bozkurt on 30.05.2024.
//

import UIKit
import RxSwift
import Kingfisher

class FavorilerVC: UIViewController {
    
    @IBOutlet weak var favoriCollectionView: UICollectionView!
    var favoriListesi = [Yemekler]()
    var viewModel = UrunDetayViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favoriCollectionView.delegate = self
        favoriCollectionView.dataSource = self
        
        viewModel.favoriListesi
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { favoriler in
                            self.favoriListesi = favoriler
                            self.favoriCollectionView.reloadData()
                        }).disposed(by: disposeBag)

                        viewModel.yrepo.loadFavorites()
        
        let tasarim = UICollectionViewFlowLayout()
        tasarim.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tasarim.minimumInteritemSpacing = 10
        tasarim.minimumLineSpacing = 10
        
        let ekranGenislik = UIScreen.main.bounds.width
        let itemGenislik = (ekranGenislik - 30) / 2
        tasarim.itemSize = CGSize(width: itemGenislik, height: itemGenislik*1.6)
        
        favoriCollectionView.collectionViewLayout = tasarim
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(guncelleFavoriler), name: NSNotification.Name("FavorilerGuncelle"), object: nil)
    }
    
    @objc func guncelleFavoriler() {
            viewModel.yrepo.loadFavorites()
        }
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
}

extension FavorilerVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriListesi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favori = favoriListesi[indexPath.row]
        
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: "favorilerHucre", for: indexPath) as! FavorilerHucre
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(favori.yemek_resim_adi!)") {
            DispatchQueue.main.async {
                hucre.imageViewFavori.kf.setImage(with: url)
            }
        }
        
        hucre.labelYemek.text = favori.yemek_adi
        hucre.labelFavoriFiyat.text = "\(favori.yemek_fiyat!) ₺"
        
        hucre.layer.borderColor = UIColor.lightGray.cgColor
        hucre.layer.borderWidth = 0.3
        hucre.layer.cornerRadius = 10.0
        
        hucre.yemek = favori
        hucre.viewModel = viewModel
            
        let favoriListesi = try! viewModel.favoriListesi.value()
        if favoriListesi.contains(where: { $0.yemek_id == favori.yemek_id }) {
            hucre.buttonFavori.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            hucre.buttonFavori.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        return hucre
    }
}
