//
//  VpnManager.swift
//  VpnZep
//
//  Created by Developer on 22.06.2024.
//

import Foundation
import NetworkExtension

class VpnManager: ObservableObject {
    
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

                        // At this point, the tunnel is configured.
                        // Attempt to start the tunnel
                        do {
                            NSLog("Starting the tunnel")
                            guard let session = tunnelManager.connection as? NETunnelProviderSession else {
                                fatalError("tunnelManager.connection is invalid")
                            }
                            try session.startTunnel()
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
                    self.wgQuickConfig = ""
                    let protocolConfiguration = NETunnelProviderProtocol()
                    protocolConfiguration.serverAddress = "VpnZep.net"
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
                            return
                        }
                    }

                    switch session.status {
                    case .connected, .connecting, .reasserting:
                        NSLog("Stopping the tunnel")
                        session.stopTunnel()
                    default:
                        break
                    }
                }
            }
        }
    
    func downloadConfigFile() {
        guard let configURL = URL(string: "http://45.159.248.107/wg0-client-zep.conf") else {
            print("Invalid URL for client configuration")
            return
        }

        let task = URLSession.shared.dataTask(with: configURL) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Failed to download client configuration: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let configContents = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.wgQuickConfig = configContents
                }
            } else {
                print("Failed to decode config file")
            }
        }
        task.resume()
    }
}
