//
//  YemeklerDaoRepository.swift
//  FoodsApp
//
//  Created by Bozkurt on 29.06.2024.
//

import Foundation
import RxSwift
import Alamofire

class YemeklerDaoRepository {
    
    var yemekListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var sepetListesi = BehaviorSubject<[SepetYemekler]>(value:[SepetYemekler]())
    var favoriListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var yemekAdet = BehaviorSubject<Int>(value: 1)
    var yemekToplamFiyat = BehaviorSubject<Int>(value: 0)
    
    init() {
            loadFavorites()
        }

    func favoriEkle(yemek: Yemekler) {
            var favoriler = try! favoriListesi.value()
            favoriler.append(yemek)
            favoriListesi.onNext(favoriler)
        saveFavorites(favoriler: favoriler)
        }

    func saveFavorites(favoriler: [Yemekler]) {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(favoriler) {
                UserDefaults.standard.set(encoded, forKey: "favoriler")
            }
        }

        func loadFavorites() {
            if let savedFavoriler = UserDefaults.standard.object(forKey: "favoriler") as? Data {
                let decoder = JSONDecoder()
                if let loadedFavoriler = try? decoder.decode([Yemekler].self, from: savedFavoriler) {
                    favoriListesi.onNext(loadedFavoriler)
                }
            }
        }
    
    func adetEkle() {
            do {
                let currentValue = try yemekAdet.value()
                yemekAdet.onNext(currentValue + 1)
            } catch {
                print("Error updating yemekAdet: \(error.localizedDescription)")
            }
        }
        
        func adetCikar() {
            do {
                let currentValue = try yemekAdet.value()
                if currentValue > 1 {
                    yemekAdet.onNext(currentValue - 1)
                }
            } catch {
                print("Error updating yemekAdet: \(error.localizedDescription)")
            }
        }
        
        func fiyatHesapla(fiyat: Int) {
            do {
                let adet = try yemekAdet.value()
                let toplamFiyat = adet * fiyat
                yemekToplamFiyat.onNext(toplamFiyat)
            } catch {
                print("Error calculating total price: \(error.localizedDescription)")
            }
        }
    
    func yemekleriYukle() {
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(YemeklerCevap.self, from: data)
                    if let liste = cevap.yemekler {
                        self.yemekListesi.onNext(liste)
                    }
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func sepeteEkle(yemek_adi:String, yemek_resim_adi:String, yemek_fiyat:Int, yemek_siparis_adet:Int, kullanici_adi:String) {
            let params:Parameters = ["yemek_adi":yemek_adi,"yemek_resim_adi":yemek_resim_adi,"yemek_fiyat":yemek_fiyat,"yemek_siparis_adet":yemek_siparis_adet,"kullanici_adi":kullanici_adi]
            
            AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php",method: .post,parameters: params).response { response
                in
                if let data = response.data{
                    do{
                        let cevap = try JSONDecoder().decode(CrudCevap.self, from: data)
                        print("-------Sepete Ekle-------")
                        print("Başarı : \(cevap.success!)")
                        print("Mesaj : \(cevap.message!)")
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
    
    func sepettekiYemekleriGetir(kullanici_adi: String) {
        let params:Parameters = ["kullanici_adi":kullanici_adi]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method: .post, parameters: params).response { response in
            if let data = response.data{
                do{
                    let cevap = try JSONDecoder().decode(SepetYemekCevap.self, from: data)
                    if let liste = cevap.sepet_yemekler {
                        self.sepetListesi.onNext(liste)
                        print("Başarı : \(cevap.success!)")
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func sepettenYemekleriSil(sepet_yemek_id:String, kullanici_adi:String) {
        let params:Parameters = ["sepet_yemek_id":sepet_yemek_id, "kullanici_adi":kullanici_adi]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(CrudCevap.self, from: data)
                        print("Başarılı : \(cevap.success!)")
                        print("Mesaj : \(cevap.message!)")
                    self.sepettekiYemekleriGetir(kullanici_adi: "Muhammet")
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
}
