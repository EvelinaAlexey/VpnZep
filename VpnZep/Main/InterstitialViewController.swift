//
//  InterstitialViewController.swift
//  VpnZep
//
//  Created by EvelinaAlexey on 28.06.2024.
//

/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */
import UIKit
import YandexMobileAds // Импорт SDK для рекламы
import Combine


protocol InterstitialAdViewControllerDelegate: AnyObject {
    func interstitialAdDidLoad()
    func interstitialAdDidFailToLoadWithError(_ error: Error)
    // Добавьте другие методы обратного вызова по мере необходимости
}

class InterstitialAdViewController: UIViewController, ObservableObject {
    var interstitialAd: InterstitialAd?
    private lazy var interstitialAdLoader: InterstitialAdLoader = {
        let loader = InterstitialAdLoader()
        loader.delegate = self
        return loader
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        loadAd()
    }

    func loadAd() {
        print("Attempting to load ad")
        let configuration = AdRequestConfiguration(adUnitID: "demo-interstitial-yandex")
        interstitialAdLoader.loadAd(with: configuration)
    }

    func presentAd() {
        guard let interstitialAd = interstitialAd else {
            print("No ad available to present")
            return
        }
        interstitialAd.show(from: self)
    }
}

// MARK: - InterstitialAdLoaderDelegate

extension InterstitialAdViewController: InterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didLoad interstitialAd: InterstitialAd) {
        print("Interstitial Ad successfully loaded")
        self.interstitialAd = interstitialAd
        self.interstitialAd?.delegate = self
        NotificationCenter.default.post(name: NSNotification.Name("AdLoaded"), object: nil)
    }

    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didFailToLoadWithError error: AdRequestError) {
        let id = error.adUnitId ?? "Unknown"
        let errorDescription = error.error.localizedDescription
        print("Failed to load Interstitial Ad with Unit ID: \(id). Error: \(errorDescription)")
    }
}

// MARK: - InterstitialAdDelegate

extension InterstitialAdViewController: InterstitialAdDelegate {
    func interstitialAd(_ interstitialAd: InterstitialAd, didFailToShowWithError error: Error) {
        print("Interstitial Ad failed to show. Error: \(error.localizedDescription)")
    }

    func interstitialAdDidShow(_ interstitialAd: InterstitialAd) {
        print("Interstitial Ad did show")
    }

    func interstitialAdDidDismiss(_ interstitialAd: InterstitialAd) {
        print("Interstitial Ad did dismiss")
        loadAd() // Повторная загрузка рекламы после закрытия
    }

    func interstitialAdDidClick(_ interstitialAd: InterstitialAd) {
        print("Interstitial Ad did click")
    }

    func interstitialAd(_ interstitialAd: InterstitialAd, didTrackImpressionWith impressionData: ImpressionData?) {
        print("Interstitial Ad did track impression")
    }
}
