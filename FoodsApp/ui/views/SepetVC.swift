//
//  SepetVC.swift
//  FoodsApp
//
//  Created by Bozkurt on 30.05.2024.
//

import UIKit

class SepetVC: UIViewController {

    @IBOutlet weak var sepetTableView: UITableView!
    @IBOutlet weak var labelSepetToplam: UILabel!
    var viewModel = SepetimViewModel()
    
    var sepetListesi = [SepetYemekler]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sepetTableView.delegate = self
        sepetTableView.dataSource = self
        
        viewModel.yrepo.sepettekiYemekleriGetir(kullanici_adi: "Muhammet")
                
                _ = viewModel.sepetListesi.subscribe(onNext: { liste in
                    self.sepetListesi = liste
                    DispatchQueue.main.async {
                        self.sepetTableView.reloadData()
                        self.updateSepetToplam()
                    }
                })
        
        sepetTableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            viewModel.yrepo.sepettekiYemekleriGetir(kullanici_adi: "Muhammet")
        
            if sepetListesi.count == 0 {
                labelSepetToplam.text = String(0)
            }
        }
    
    @IBAction func buttonSepetOnayla(_ sender: Any) {
        let alert = UIAlertController(title: "Başarılı", message: "Satın alım başarıyla gerçekleşti.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Tamam", style: .default) { _ in
                }
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
    }
    
    func updateSepetToplam() {
            let toplam = sepetListesi.reduce(0) { (result, sepet) -> Int in
                if let yemekFiyat = sepet.yemek_fiyat, let yemekAdet = sepet.yemek_siparis_adet, let yf = Int(yemekFiyat), let ad = Int(yemekAdet) {
                    return result + (yf * ad)
                }
                return result
            }
            labelSepetToplam.text = "\(toplam) ₺"
        }
}

extension SepetVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sepetListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sepet = sepetListesi[indexPath.row]
        
        let hucre = tableView.dequeueReusableCell(withIdentifier: "sepetHucre") as! SepetHucre
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(sepet.yemek_resim_adi!)"){
                    DispatchQueue.main.async {
                        hucre.imageViewYemek.kf.setImage(with: url)
                    }
                }
        
        hucre.labelYemekAd.text = sepet.yemek_adi
        hucre.labelAdet.text = "Toplam: \(sepet.yemek_siparis_adet!)"
        hucre.labelFiyat.text = "\(sepet.yemek_fiyat!) ₺"
        
        if let yemekFiyat = sepet.yemek_fiyat, let yemekAdet = sepet.yemek_siparis_adet, let yf = Int(yemekFiyat), let ad = Int(yemekAdet) {
                    let result = yf * ad
            hucre.labelToplamFiyat.text = "\(result)"
                } else {
                    print("Fiyat veya adet değerleri uygun formatta değil.")
                }
        
        hucre.backgroundColor = UIColor(white: 0.95, alpha: 1)
        hucre.hucreArkaPlan.layer.cornerRadius = 10.0
        
        hucre.selectionStyle = .none 
        
        hucre.sepetVC = self
        hucre.sepetYemek = sepet
        
        return hucre
    }
    
    
}
