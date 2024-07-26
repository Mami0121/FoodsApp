//
//  SepetViewModel.swift
//  FoodsApp
//
//  Created by Bozkurt on 16.07.2024.
//

import Foundation
import RxSwift

class SepetimViewModel {
    
    var yrepo = YemeklerDaoRepository()
       var sepetListesi = BehaviorSubject<[SepetYemekler]>(value:[SepetYemekler]())
       var yemekAdet = BehaviorSubject<Int>(value: 1)
       var yemekToplamFiyat = BehaviorSubject<Int>(value: 0)
    
       init(){
           yemekAdet = yrepo.yemekAdet
           yemekToplamFiyat = yrepo.yemekToplamFiyat
           sepetListesi = yrepo.sepetListesi
       }
       
       func sepettekiYemekleriGetir(kullanici_adi: String){
           yrepo.sepettekiYemekleriGetir(kullanici_adi: kullanici_adi)
           
       }

    func yemekSil(sepet_yemek_id:String, kullanici_adi:String) {
        yrepo.sepettenYemekleriSil(sepet_yemek_id: sepet_yemek_id, kullanici_adi: kullanici_adi)
    }
    
}
