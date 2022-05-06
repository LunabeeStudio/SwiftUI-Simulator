//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/01.
//

import Foundation

private let userDefaultsSystemKeys: [String] = [
    "AddingEmojiKeybordHandled",
    "CarCapabilities",
    "MSVLoggingMasterSwitchEnabledKey",
    "PreferredLanguages",
]

private let userDefaultsSystemKeyPrefixes: [String] = [
    "Apple",
    "com.apple.",
    "internalSettings.",
    "METAL_",
    "INNext",
    "AK",
    "NS",
    "PK",
    "WebKit",
]

enum UserDefaultsType: String {
    case user
    case system
}

//
// Stored as JSON data.
//
struct JSONData {
    let dictionary: [String: Any]
}

//
// Stored as JSON string.
//
// e.g.
// `{"rawValue":{"red":0,"alpha":1,"blue":0,"green":0}}`)
//
struct JSONString {
    let dictionary: [String: Any]
}

private let repository = "YusukeHosonuma/SwiftUI-Simulator"
private let ossVersion = "1.6.0" // 💡 Please update version number when data incompatibility occur.

extension UserDefaults {
    static var simulatorKeyPrefix: String { "\(repository)/\(ossVersion)/" }

    var allKeys: [String] {
        Array(dictionaryRepresentation().keys.filter { isOSSKey($0) == false })
    }

    var systemKeys: [String] {
        allKeys.filter { isSystemKey($0) }
    }

    var userKeys: [String] {
        allKeys.filter { isSystemKey($0) == false }
    }

    func extractKeys(of type: UserDefaultsType) -> [String] {
        switch type {
        case .user: return userKeys
        case .system: return systemKeys
        }
    }

    func lookup(forKey key: String) -> Any? {
        if let _ = value(forKey: key) as? Data, let url = url(forKey: key) {
            return url
        }

        if let dict = dictionary(forKey: key) {
            return dict
        }

        if let data = data(forKey: key),
           let decoded = try? JSONSerialization.jsonObject(with: data),
           let dict = decoded as? [String: Any]
        {
            return JSONData(dictionary: dict)
        }

        if let string = string(forKey: key),
           string.hasPrefix("{"),
           string.hasSuffix("}"),
           let dict = string.jsonToDictionary()
        {
            return JSONString(dictionary: dict)
        }

        return value(forKey: key)
    }

    func removeAll(of type: UserDefaultsType) {
        for key in extractKeys(of: type) {
            removeObject(forKey: key)
        }
    }

    // MARK: Private

    private func isOSSKey(_ key: String) -> Bool {
        key.hasPrefix(repository)
    }

    private func isSystemKey(_ key: String) -> Bool {
        userDefaultsSystemKeys.contains(key) ||
            userDefaultsSystemKeyPrefixes.contains { key.hasPrefix($0) }
    }
}
