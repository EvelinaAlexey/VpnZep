//
//  VpnManager.swift
//  VpnZep
//
//  Created by Developer on 22.06.2024.
//

import Foundation
import NetworkExtension
import GRDWireGuardKit
import SwiftUI
import Combine

class VpnManager: ObservableObject {
    
//    @Published var status = false

    var vpnManager: NETunnelProviderManager?
    
    var ava = false
    
    @Published var vpnStatus: NEVPNStatus = .disconnected
    
    private var vpnStatusObserver: AnyCancellable?

    init() {
        loadVPNStatus()

        observeVPNStatusChanges()
    }
    
    deinit {
        vpnStatusObserver?.cancel()
    }

    @Published var wgQuickConfig: String = """
"""
    
    func turnOnTunnel(completionHandler: @escaping (Bool) -> Void) {
            // We use loadAllFromPreferences to see if this app has already added a tunnel
            // to iOS Settings or (macOS Preferences)
            NETunnelProviderManager.loadAllFromPreferences { tunnelManagersInSettings, error in
                if let error = error {
                    NSLog("Error (loadAllFromPreferences): \(error)")
                    completionHandler(false)
                    return
                }

                // If the app has already added a tunnel to Settings, we are going to modify that.
                // If not, we create a new instance and save that to Settings.
                // We will always have either 0 or 1 tunnel only in Settings for this app.
                let preExistingTunnelManager = tunnelManagersInSettings?.first
                let tunnelManager = preExistingTunnelManager ?? NETunnelProviderManager()

                // Configure the custom VPN protocol
                let protocolConfiguration = NETunnelProviderProtocol()

                // Set the tunnel extension's bundle id
                protocolConfiguration.providerBundleIdentifier = "EvelinaAlexey.VpnZep.TunnelExtension"

                // Set the server address as a non-nil string.
                // It would be good to provide the server's domain name or IP address.
                protocolConfiguration.serverAddress = "VpnZep.net"

//                let wgQuickConfig = self.config

                protocolConfiguration.providerConfiguration = [
                    "wgQuickConfig": self.wgQuickConfig
                ]

                tunnelManager.protocolConfiguration = protocolConfiguration
                tunnelManager.isEnabled = true

                // Save the tunnel to preferences.
                // This would modify the existing tunnel, or create a new one.
                tunnelManager.saveToPreferences { error in
                    if let error = error {
                        NSLog("Error (saveToPreferences): \(error)")
                        completionHandler(false)
                        return
                    }
                    // Load it back so we have a valid usable instance.
                    tunnelManager.loadFromPreferences { error in
                        if let error = error {
                            NSLog("Error (loadFromPreferences): \(error)")
                            completionHandler(false)
                            return
                        }
                        self.vpnStatus =  tunnelManager.connection.status
                        // At this point, the tunnel is configured.
                        // Attempt to start the tunnel
                        do {
                            NSLog("Starting the tunnel")
                            guard let session = tunnelManager.connection as? NETunnelProviderSession else {
                                fatalError("tunnelManager.connection is invalid")
                            }
                            try session.startTunnel()
                            self.vpnStatus = .connected // Обновляем статус VPN

    
                        } catch {
                            NSLog("Error (startTunnel): \(error)")
                            completionHandler(false)
                        }
                        completionHandler(true)
                    }
                }
            }
        }

        func turnOffTunnel() {
            NETunnelProviderManager.loadAllFromPreferences { tunnelManagersInSettings, error in
                if let error = error {
                    NSLog("Error (loadAllFromPreferences): \(error)")
                    return
                }
                if let tunnelManager = tunnelManagersInSettings?.first {
                    guard let session = tunnelManager.connection as? NETunnelProviderSession else {
                        fatalError("tunnelManager.connection is invalid")
                    }
//                    self.wgQuickConfig = ""
//                    let protocolConfiguration = NETunnelProviderProtocol()
//                    protocolConfiguration.serverAddress = "VpnZep.net"
//                    protocolConfiguration.providerConfiguration = [
//                        "wgQuickConfig": self.wgQuickConfig
//                    ]
//                    tunnelManager.protocolConfiguration = protocolConfiguration
//                    tunnelManager.isEnabled = true
//
//                    // Save the tunnel to preferences.
//                    // This would modify the existing tunnel, or create a new one.
//                    tunnelManager.saveToPreferences { error in
//                        if let error = error {
//                            NSLog("Error (saveToPreferences): \(error)")
//                            return
//                        }
//                    }
                    let protocolConfiguration = NETunnelProviderProtocol()

                    switch session.status {
                    case .connected, .connecting, .reasserting:
                        NSLog("Stopping the tunnel")
                        session.stopTunnel()
                        self.vpnStatus = .disconnected // Обновляем статус VPN

//                        protocolConfiguration.providerConfiguration?.removeAll()

//                        self.vpnStatus = false
//                        UserDefaults.standard.set(self.vpnStatus, forKey: "vpnStatus")
                    default:
                        break
                    }
                }
            }
        }
    
    
    func formatConfigString(_ configString: String) -> String {
        var formattedConfig = ""
        
        // Удаление лишних пробелов перед началом каждой секции [Interface] или [Peer]
        var cleanedConfig = configString.replacingOccurrences(of: " = ", with: "=")
        cleanedConfig = cleanedConfig.replacingOccurrences(of: "  ", with: "\n")
        
        // Разделение конфигурации по секциям [Interface] и [Peer]
        let components = cleanedConfig.components(separatedBy: "  ")

        for component in components {
            // Разделение компонента на строки
            let lines = component.components(separatedBy: " ")
            
            // Пропуск пустых элементов
            for line in lines {
                if line.isEmpty {
                    continue
                }
                
                // Добавление форматированной строки
                formattedConfig += "\(line)\n"
            }
        }
        wgQuickConfig = formattedConfig
        
        return formattedConfig
    }
    
    private func observeVPNStatusChanges() {
        self.vpnStatusObserver = NotificationCenter.default.publisher(for: .NEVPNStatusDidChange)
            .sink { _ in
//                self.loadVPNStatus()
            }
    }
    func loadVPNStatus() {
        NETunnelProviderManager.loadAllFromPreferences { managers, error in
            if let error = error {
                print("Error loading VPN preferences: \(error.localizedDescription)")
                self.vpnStatus = .disconnected
                return
            }
            
            guard let manager = managers?.first else {
                self.vpnStatus = .disconnected
                return
            }
            
            self.vpnManager = manager
            
            manager.loadFromPreferences { error in
                if let error = error {
                    print("Error loading VPN preferences: \(error.localizedDescription)")
                    self.vpnStatus = .disconnected
                    return
                }
                
                self.vpnStatus = manager.connection.status
                if self.vpnStatus == .disconnected {
                    self.ava = true
                }
            }
        }
    }
}








