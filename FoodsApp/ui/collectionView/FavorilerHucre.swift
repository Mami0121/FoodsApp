//
//  FavorilerHucre.swift
//  FoodsApp
//
//  Created by Bozkurt on 20.07.2024.
//

import UIKit

class FavorilerHucre: UICollectionViewCell {
    
    @IBOutlet weak var imageViewFavori: UIImageView!
    @IBOutlet weak var labelYemek: UILabel!
    @IBOutlet weak var labelFavoriFiyat: UILabel!
    @IBOutlet weak var buttonFavori: UIButton!
    var viewModel: UrunDetayViewModel?
    var yemek: Yemekler?
    
    @IBAction func buttonFavori(_ sender: Any) {
        guard let yemek = yemek, let viewModel = viewModel else { return }
                
                var favoriListesi = try! viewModel.favoriListesi.value()
                
                if let index = favoriListesi.firstIndex(where: { $0.yemek_id == yemek.yemek_id }) {
                    favoriListesi.remove(at: index)
                    
                } else {
            viewModel.favoriEkle(yemek: yemek)
                }
                
                viewModel.yrepo.saveFavorites(favoriler: favoriListesi)
                viewModel.yrepo.loadFavorites()
            }
    
    
    }
    
