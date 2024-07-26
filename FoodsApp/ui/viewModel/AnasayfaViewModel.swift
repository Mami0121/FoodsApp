//
//  AnasayfaViewModel.swift
//  FoodsApp
//
//  Created by Bozkurt on 11.07.2024.
//

import Foundation
import RxSwift

class AnasayfaViewModel {
    
    var yrepo = YemeklerDaoRepository()
    var yemekListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    
    init() {
        yemekListesi = yrepo.yemekListesi
        yemekleriYukle()
    }
    
    func yemekleriYukle() {
        yrepo.yemekleriYukle()
    }
    
    func sepeteEkle(yemek: Yemekler) {
            let yemekAdet = 1
            yrepo.sepeteEkle(yemek_adi: yemek.yemek_adi!, yemek_resim_adi: yemek.yemek_resim_adi!, yemek_fiyat: Int(yemek.yemek_fiyat!)!, yemek_siparis_adet: yemekAdet, kullanici_adi: "Muhammet")
        }
        
    func favoriEkle(yemek: Yemekler) {
        yrepo.favoriEkle(yemek: yemek)
    }
    
}
