//
//  AnasayfaVC.swift
//  FoodsApp
//
//  Created by Bozkurt on 30.05.2024.
//

import UIKit
import Kingfisher
import RxSwift

class AnasayfaVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var yemeklerCollectionView: UICollectionView!
    var yemekListesi = [Yemekler]()
    private let disposeBag = DisposeBag()
    
    var viewModel = AnasayfaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yemeklerCollectionView.delegate = self
        yemeklerCollectionView.dataSource = self
        
        _ = viewModel.yemekListesi.subscribe(onNext: { liste in
            self.yemekListesi = liste
            self.yemeklerCollectionView.reloadData()
        })
        
        searchBar.delegate = self
        
        if let tabBar = tabBarController?.tabBar {
                    CustomTabBar.setupTabBarAppearance(tabBar: tabBar)
                }
        
        let tasarim = UICollectionViewFlowLayout()
        tasarim.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tasarim.minimumInteritemSpacing = 10
        tasarim.minimumLineSpacing = 10
        
        let ekranGenislik = UIScreen.main.bounds.width
        let itemGenislik = (ekranGenislik - 30) / 2
        tasarim.itemSize = CGSize(width: itemGenislik, height: itemGenislik*1.3)
        
        yemeklerCollectionView.collectionViewLayout = tasarim
    }
}

extension AnasayfaVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return yemekListesi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let yemek = yemekListesi[indexPath.row]
        
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: "yemeklerHucre", for: indexPath) as! YemeklerHucre

        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemek_resim_adi!)") {
            DispatchQueue.main.async {
                hucre.imageViewYemek.kf.setImage(with: url)
            }
        }
        
        hucre.yemekLabel.text = yemek.yemek_adi!
        hucre.fiyatLabel.text = "\(yemek.yemek_fiyat!) ₺"
        hucre.aciklamalabel.text = "Ücretsiz Gönderim"
        
        hucre.layer.borderColor = UIColor.lightGray.cgColor
        hucre.layer.borderWidth = 0.5
        hucre.layer.cornerRadius = 10.0
        
        hucre.yemek = yemek
        hucre.viewModel = viewModel
        
        return hucre
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let yemek = yemekListesi[indexPath.row]
        performSegue(withIdentifier: "toDetay", sender: yemek)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            if let yemek = sender as? Yemekler {
                let gidilecekVC = segue.destination as! YemeklerDetayVC
                gidilecekVC.yemek = yemek
            }
        }
    }
}

extension AnasayfaVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            _ = viewModel.yemekListesi.subscribe(onNext: { liste in
                self.yemekListesi = liste
                self.yemeklerCollectionView.reloadData()
            }).disposed(by: disposeBag)
        } else {
            _ = viewModel.yemekListesi.subscribe(onNext: { liste in
                self.yemekListesi = liste.filter { $0.yemek_adi!.lowercased().contains(searchText.lowercased()) }
                self.yemeklerCollectionView.reloadData()
            }).disposed(by: disposeBag)
        }
    }
}
