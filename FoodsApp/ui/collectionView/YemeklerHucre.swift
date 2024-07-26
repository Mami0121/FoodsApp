//
//  YemeklerHucre.swift
//  FoodsApp
//
//  Created by Bozkurt on 1.06.2024.
//

import UIKit

class YemeklerHucre: UICollectionViewCell {
 
    @IBOutlet weak var imageViewYemek: UIImageView!
    @IBOutlet weak var yemekLabel: UILabel!
    @IBOutlet weak var aciklamalabel: UILabel!
    @IBOutlet weak var fiyatLabel: UILabel!
    
    var yemek: Yemekler?
    var viewModel: AnasayfaViewModel?
    
    @IBAction func sepetButton(_ sender: Any) {
        guard let yemek = yemek else { return }
            viewModel?.sepeteEkle(yemek: yemek)
            print("\(yemek.yemek_adi!) sepete eklendi")
    }
    
    @IBAction func favoriButtton(_ sender: Any) {
         guard let yemek = yemek else { return }
           viewModel?.favoriEkle(yemek: yemek)
                
    NotificationCenter.default.post(name: NSNotification.Name("FavorilerGuncelle"), object: nil)
    }
    
}
