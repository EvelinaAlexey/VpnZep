//
//  VpnManager.swift
//  VpnZep
//
//  Created by Developer on 22.06.2024.
//

import Foundation
import NetworkExtension

class VpnManager: ObservableObject {
    
    
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
                protocolConfiguration.providerBundleIdentifier = "evelina.qkwkqkqkq.networkex"

                // Set the server address as a non-nil string.
                // It would be good to provide the server's domain name or IP address.
                protocolConfiguration.serverAddress = "31.128.42.215"

                let wgQuickConfig = """
                [Interface]
                PrivateKey = OMDJdvRLIuqpbkrTh45GMCuudX3s4H+Ez8pus+jWCGw=
                Address = 10.66.66.2/32, fd42:42:42::2/128
                DNS = 1.1.1.1, 1.0.0.1

                [Peer]
                PublicKey = muo7ufSNtsg7pI+Q5+hef6WdVz3lWceDboe5jkkdN0s=
                PresharedKey = CYK9i6PBe6t9Ghi5qMEV92WI0KukPerniaLwbcYAOug=
                AllowedIPs = 0.0.0.0/0, ::/0
                Endpoint = 31.128.42.215:55375
                """

                protocolConfiguration.providerConfiguration = [
                    "wgQuickConfig": wgQuickConfig
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
}
