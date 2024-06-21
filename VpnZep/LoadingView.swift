//
//  DownloadRingView.swift
//  VpnFly
//
//  Created by Эвелина Пенькова on 15.06.2024.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        ZStack {
         
            VStack(spacing: 20) {
                ProgressView()
                   .scaleEffect(3) // Увеличивает размер ProgressView
                   .tint(Color.purple)
            }
            .offset(y: -70)
        }
    }
}
