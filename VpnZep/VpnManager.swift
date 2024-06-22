//
//  VpnManager.swift
//  VpnZep
//
//  Created by Developer on 22.06.2024.
//

import Foundation
import NetworkExtension
//jggghhhjjjd
class VPN: ObservableObject {
    
    let vpnManager = NEVPNManager.shared();
    
    private var vpnLoadHandler: (Error?) -> Void { return
        { (error:Error?) in
            if ((error) != nil) {
                print("Could not load VPN Configurations")
                return;
            }
            let p = NEVPNProtocolIPSec()
            p.username = "vpn"
            p.serverAddress = "219.100.37.187"
            p.authenticationMethod = NEVPNIKEAuthenticationMethod.sharedSecret
            
            let kcs = KeychainService();
            kcs.save(key: "SHARED", value: "vpn")
            kcs.save(key: "VPN_PASSWORD", value: "vpn")
            p.sharedSecretReference = kcs.load(key: "SHARED")
            p.passwordReference = kcs.load(key: "VPN_PASSWORD")
            p.useExtendedAuthentication = true
            p.disconnectOnSleep = false
            self.vpnManager.protocolConfiguration = p
            self.vpnManager.localizedDescription = "VPN ZEP"
            self.vpnManager.isEnabled = true
            self.vpnManager.saveToPreferences(completionHandler: self.vpnSaveHandler)
        } }
    
    private var vpnSaveHandler: (Error?) -> Void { return
        { (error:Error?) in
            if (error != nil) {
                print("Could not save VPN Configurations")
                return
            } else {
                do {
                    try self.vpnManager.connection.startVPNTunnel()
                } catch let error {
                    print("Error starting VPN Connection \(error.localizedDescription)");
                }
            }
        }
        //        self.vpnlock = false
    }
    
    func connectVPN() {
        //For no known reason the process of saving/loading the VPN configurations fails.On the 2nd time it works
        do {
            try self.vpnManager.loadFromPreferences(completionHandler: self.vpnLoadHandler)
        } catch let error {
            print("Could not start VPN Connection: \(error.localizedDescription)" )
        }
    }
    
    func disconnectVPN() ->Void {
        vpnManager.connection.stopVPNTunnel()
    }
}
