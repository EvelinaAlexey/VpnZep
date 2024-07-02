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
                protocolConfiguration.providerBundleIdentifier = "EvelinaAlexey.VpnZep.TunnelExtension"

                // Set the server address as a non-nil string.
                // It would be good to provide the server's domain name or IP address.
                protocolConfiguration.serverAddress = "VpnZep.net"

                let wgQuickConfig = """
                [Interface]
                PrivateKey = iIMOLUQ41WcC6wif7W+WU45XdOZPZhK/PJy6qn7/ZWU=
                Address = 10.66.66.2/32,fd42:42:42::2/128
                DNS = 1.1.1.1,1.0.0.1

                [Peer]
                PublicKey = DaQ/PgPGoXk5z5xDK+yO00Ry1MAvmrHgu3rHOTPDzAo=
                PresharedKey = fnyiJDJ4zK8V3O0P+hmDG9Rxf6Oq8jzc6vPcvuFF9ho=
                Endpoint = 45.159.248.107:61056
                AllowedIPs = 0.0.0.0/0,::/0
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
