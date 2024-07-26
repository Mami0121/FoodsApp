//
//  YemeklerDetayVC.swift
//  FoodsApp
//
//  Created by Bozkurt on 3.06.2024.
//

import UIKit
import Kingfisher
import Alamofire

class YemeklerDetayVC: UIViewController {

    @IBOutlet weak var yemekImageView: UIImageView!
    @IBOutlet weak var fiyatLabel: UILabel!
    @IBOutlet weak var isimLabel: UILabel!
    @IBOutlet weak var toplamFiyatLabel: UILabel!
    @IBOutlet weak var adetLabel: UILabel!
    
    @IBOutlet weak var favoriEkleButton: UIBarButtonItem!
    var yemek:Yemekler?
    var viewModel = UrunDetayViewModel()
    var sepetListesi = [SepetYemekler]()
    var userName = "Muhammet"
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            if let y = yemek {
                
                isimLabel.text = y.yemek_adi
                fiyatLabel.text = y.yemek_fiyat!
                
                if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(y.yemek_resim_adi!)"){
                    DispatchQueue.main.async {
                        self.yemekImageView.kf.setImage(with: url)
                    }
                    _ = viewModel.sepetListesi.subscribe(onNext: { liste in
                        self.sepetListesi = liste
                    })
                    _ = viewModel.yrepo.yemekAdet.subscribe(onNext: { adet in
                        self.adetLabel.text = String(adet)
                    })
                    _ = viewModel.yrepo.yemekToplamFiyat.subscribe(onNext: { yemekFiyat in
                         self.toplamFiyatLabel.text = String(yemekFiyat)
                    })
                }
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // Tab barı gizle
            self.tabBarController?.tabBar.isHidden = true
        toplamFiyatLabel.text = yemek?.yemek_fiyat
        }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            // Tab barı göster
            self.tabBarController?.tabBar.isHidden = false
        }
    
    @IBAction func azaltButton(_ sender: Any) {
        viewModel.adetCikar()
        viewModel.yrepo.fiyatHesapla(fiyat: Int((yemek?.yemek_fiyat)!)!)
    }
    
    @IBAction func arttırButon(_ sender: Any) {
        viewModel.adetEkle()
        viewModel.yrepo.fiyatHesapla(fiyat: Int((yemek?.yemek_fiyat)!)!)
    }
    
    @IBAction func favoriEkleButton(_ sender: Any) {
        if let y = yemek {
                    viewModel.favoriEkle(yemek: y)
            NotificationCenter.default.post(name: NSNotification.Name("FavorilerGuncelle"), object: nil)
                }
    }
    
    @IBAction func sepeteEkleButton(_ sender: Any) {
        if let ym = yemek {
                    if let yemek_adi = isimLabel.text, let yemek_resim_adi = ym.yemek_resim_adi, let yemek_fiyat = fiyatLabel.text, let yemek_siparis_adet = adetLabel.text {
                        viewModel.sepeteEkle(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: Int(yemek_fiyat)!, yemek_siparis_adet: Int(yemek_siparis_adet)!, kullanici_adi: userName)
                    }
                }
    }
}

