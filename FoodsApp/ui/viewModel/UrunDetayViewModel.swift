//
//  UrunDetayViewModel.swift
//  FoodsApp
//
//  Created by Bozkurt on 11.07.2024.
//

import Foundation
import RxSwift

class UrunDetayViewModel {
    
    var sepetListesi = BehaviorSubject<[SepetYemekler]>(value:[SepetYemekler]())
    var favoriListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var yrepo = YemeklerDaoRepository()
    var yemekAdet = BehaviorSubject<Int>(value: 1)
    var yemekToplamFiyat = BehaviorSubject<Int>(value: 0)
    private let disposeBag = DisposeBag()
    
    init() {
        yrepo.favoriListesi
                    .observe(on: MainScheduler.asyncInstance)
                    .subscribe(onNext: { favoriler in
                        self.favoriListesi.onNext(favoriler)
                    }).disposed(by: disposeBag)
        
        yemekAdet = yrepo.yemekAdet
        yemekToplamFiyat = yrepo.yemekToplamFiyat
        
        sepetListesi = yrepo.sepetListesi
        favoriListesi = yrepo.favoriListesi
    }
    
    func adetEkle (){
            yrepo.adetEkle()
            
        }
        func adetCikar (){
            yrepo.adetCikar()
        }
    
    func sepeteEkle(yemek_adi:String, yemek_resim_adi:String, yemek_fiyat:Int, yemek_siparis_adet:Int, kullanici_adi:String) {
            yrepo.sepeteEkle(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet,  kullanici_adi: kullanici_adi)
        }
    
    func favoriEkle(yemek: Yemekler) {
            yrepo.favoriEkle(yemek: yemek)
        }
}
