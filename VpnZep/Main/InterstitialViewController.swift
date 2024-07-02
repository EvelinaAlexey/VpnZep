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

import YandexMobileAds
import UIKit

final class InterstitialAdViewController: UIViewController {
    var interstitialAd: InterstitialAd?
    private lazy var interstitialAdLoader: InterstitialAdLoader = {
        let loader = InterstitialAdLoader()
        loader.delegate = self
        return loader
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAd()
    }

    func loadAd() {
        // Replace demo-interstitial-yandex with your actual Ad Unit ID
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

    private func makeMessageDescription(_ interstitialAd: InterstitialAd) -> String {
        "Interstitial Ad with Unit ID: \(String(describing: interstitialAd.adInfo?.adUnitId))"
    }
}

// MARK: - YMAInterstitialAdLoaderDelegate

extension InterstitialAdViewController: InterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didLoad interstitialAd: InterstitialAd) {
        self.interstitialAd = interstitialAd
        self.interstitialAd?.delegate = self
        print("\(makeMessageDescription(interstitialAd)) loaded")
    }

    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didFailToLoadWithError error: AdRequestError) {
        let id = error.adUnitId
        let error = error.error
        print("Loading failed for Ad with Unit ID: \(String(describing: id)). Error: \(String(describing: error))")
    }
}

// MARK: - YMARewardedAdDelegate

extension InterstitialAdViewController: InterstitialAdDelegate {
    func interstitialAd(_ interstitialAd: InterstitialAd, didFailToShowWithError error: Error) {
        print("\(makeMessageDescription(interstitialAd)) failed to show. Error: \(error)")
    }

    func interstitialAdDidShow(_ interstitialAd: InterstitialAd) {
        print("\(makeMessageDescription(interstitialAd)) did show")
    }

    func interstitialAdDidDismiss(_ interstitialAd: InterstitialAd) {
        print("\(makeMessageDescription(interstitialAd)) did dismiss")
        loadAd()  // Reload the ad after it is dismissed
    }

    func interstitialAdDidClick(_ interstitialAd: InterstitialAd) {
        print("\(makeMessageDescription(interstitialAd)) did click")
    }

    func interstitialAd(_ interstitialAd: InterstitialAd, didTrackImpressionWith impressionData: ImpressionData?) {
        print("\(makeMessageDescription(interstitialAd)) did track impression")
    }
}
