//
//  KeyChainService.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 05/01/2022.
//

import Foundation

func saveToken(token: Data, service: String, account: String) {
    let query: [String: AnyObject] = [
        kSecAttrService as String: service as AnyObject,
        kSecAttrAccount as String: account as AnyObject,
        kSecClass as String : kSecClassGenericPassword,
        kSecValueData as String: token as AnyObject
    ]
    
    
    let status = SecItemAdd(query as CFDictionary, nil)
    
    if status == errSecDuplicateItem{
        print("duplicate")
        return
    }
    
    guard status == errSecSuccess else {
        print(status)
        print("Something unexpected happened")
        return
    }
}

func getToken(service: String, account: String) -> Data {
    let query: [String: AnyObject] = [
        kSecAttrService as String: service as AnyObject,
        kSecAttrAccount as String: account as AnyObject,
        kSecClass as String: kSecClassGenericPassword,
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnData as String: kCFBooleanTrue
    ]

    var itemCopy: AnyObject?
    let status = SecItemCopyMatching(
        query as CFDictionary,
        &itemCopy
    )
    
    let response : Data = " ".data(using: .utf8)!

    guard status != errSecItemNotFound else {
        print("Item bestaat niet")
        return response
    }

    guard status == errSecSuccess else {
        print("Iet onverwachts")
        return response
    }

    guard let token = itemCopy as? Data else {
        print("Verkeerde format")
        return response
    }

    return token
}

func deleteToken(service: String, account: String) {
    let query: [String: AnyObject] = [
        kSecAttrService as String: service as AnyObject,
        kSecAttrAccount as String: account as AnyObject,
        kSecClass as String: kSecClassGenericPassword
    ]

    let status = SecItemDelete(query as CFDictionary)

    guard status == errSecSuccess else {
        return
    }
}
