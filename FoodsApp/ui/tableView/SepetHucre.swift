//
//  SepetCell.swift
//  FoodsApp
//
//  Created by Bozkurt on 14.07.2024.
//

import UIKit

class SepetHucre: UITableViewCell {

    @IBOutlet weak var hucreArkaPlan: UIView!
    @IBOutlet weak var imageViewYemek: UIImageView!
    @IBOutlet weak var labelYemekAd: UILabel!
    @IBOutlet weak var labelAdet: UILabel!
    @IBOutlet weak var labelFiyat: UILabel!
    @IBOutlet weak var labelToplamFiyat: UILabel!
    
    var sepetVC: SepetVC?
    var sepetYemek: SepetYemekler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    @IBAction func buttonSil(_ sender: Any) {
        if let sepetYemek = sepetYemek {
                    sepetVC?.viewModel.yemekSil(sepet_yemek_id: sepetYemek.sepet_yemek_id!, kullanici_adi: "Muhammet")
                }
    }
}
