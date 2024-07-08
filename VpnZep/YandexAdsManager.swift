//
//  YandexAdsManager.swift
//  VpnZep
//
//  Created by Developer on 08.07.2024.
//

import Foundation
import YandexMobileAds
import SwiftUI

final class InterstitialViewController: UIViewController, InterstitialAdDelegate {
    
    private var interstitialAd: InterstitialAd?
    
    private lazy var interstitialAdLoader: InterstitialAdLoader = {
        let loader = InterstitialAdLoader()
        loader.delegate = self
        return loader
    }()
    
    func loadAd() {
        let configuration = AdRequestConfiguration(adUnitID: "demo-interstitial-yandex")
        interstitialAdLoader.loadAd(with: configuration)
    }
    
    func showAd() {
        interstitialAd?.show(from: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAd()
    }

}

extension InterstitialViewController: InterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didLoad interstitialAd: InterstitialAd) {
        self.interstitialAd = interstitialAd
        self.interstitialAd?.delegate = self

        showAd()
    }
//
    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didFailToLoadWithError error: AdRequestError) {
        // This method will call after getting any error while loading the ad
        print("aaa")
    }
}

struct AdsView: UIViewControllerRepresentable {
    typealias UIViewControllerType = InterstitialViewController
    func makeUIViewController(context: Context) -> InterstitialViewController {
        return InterstitialViewController()
    }
    
    func updateUIViewController(_ uiViewController: InterstitialViewController, context: Context) {
        
    }
    
}
