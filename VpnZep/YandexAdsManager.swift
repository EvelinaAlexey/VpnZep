//
//  YandexAdsManager.swift
//  VpnZep
//
//  Created by Developer on 08.07.2024.
//

import Foundation
import YandexMobileAds
import SwiftUI
import UIKit
//
//class InterstitialAdManager: NSObject, ObservableObject, InterstitialAdDelegate, InterstitialAdLoaderDelegate {
//    @Published var interstitialAd: InterstitialAd?
//    private lazy var interstitialAdLoader: InterstitialAdLoader = {
//        let loader = InterstitialAdLoader()
//        loader.delegate = self
//        return loader
//    }()
//    
//    override init() {
//        super.init()
//        loadAd()
//    }
//    
//    func loadAd() {
//        let configuration = AdRequestConfiguration(adUnitID: "demo-interstitial-yandex")
//        interstitialAdLoader.loadAd(with: configuration)
//        print("load ads")
//    }
//    
//    func showAd(from viewController: UIViewController) {
//        
//
//        if let ad = interstitialAd {
//            ad.show(from: viewController)
//        } else {
//            loadAd() // Загружаем новую рекламу, если текущая отсутствует
//            print("load aaa")
//
//        }
//    }
//    
//    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didLoad interstitialAd: InterstitialAd) {
//        self.interstitialAd = interstitialAd
//        self.interstitialAd?.delegate = self
//
//    }
//    
//    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didFailToLoadWithError error: AdRequestError) {
//        print("Failed to load ad: \(error)")
//        // Попробовать загрузить рекламу снова с задержкой
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.loadAd()
//        }
//    }
//    
//    func interstitialAdDidDismiss(_ ad: InterstitialAd) {
//        // Загружаем новую рекламу после закрытия текущей
//        loadAd()
//        print("load again")
//    }
//}
