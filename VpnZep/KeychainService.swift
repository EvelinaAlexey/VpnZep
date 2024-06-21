//
//  KeychainService.swift
//  VpnZep
//
//  Created by Developer on 22.06.2024.
//

import Foundation
import Security

class KeychainService {

    func save(key: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            print("Сохранен ключ \(key) в Keychain")
        } else {
            print("Не удалось сохранить ключ \(key) в Keychain, статус: \(status)")
        }
    }

    func load(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            print("Загружен ключ \(key) из Keychain")
            return dataTypeRef as? Data
        } else {
            print("Не удалось загрузить ключ \(key) из Keychain, статус: \(status)")
            return nil
        }
    }
}
