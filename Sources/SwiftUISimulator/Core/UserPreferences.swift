//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/16.
//

import SwiftUI

//
// Presets
//
private let devicePresets: Set<Device> = [
    .iPodTouch,
    .iPhoneSE,
    .iPhone11,
    .iPhone13ProMax,
    .iPadMini_5th,
]
private let localeIdentifierPresets: Set<String> = ["en_US", "ja_JP"]
private let calendarIdentifierPresets: Set<Calendar.Identifier> = [.iso8601, .japanese]
private let timeZonePresetes: Set<TimeZones> = [
    .asiaTokyo,
    .americaNewYork,
]

final class UserPreferences: ObservableObject {
    @Published var device: Device? {
        didSet {
            saveDevice()
        }
    }

    @Published var enableDevices: Set<Device> {
        didSet {
            saveEnableDevices()
        }
    }

    @Published var enableLocales: Set<String> {
        didSet {
            saveEnableLocales()
        }
    }

    @Published var enableCalendars: Set<Calendar.Identifier> {
        didSet {
            saveEnableCalendars()
        }
    }

    @Published var enableTimeZones: Set<TimeZones> {
        didSet {
            saveEnableTimeZones()
        }
    }

    public init(
        defaultDevices: Set<Device>? = nil,
        defaultLocaleIdentifiers: Set<String>? = nil,
        defaultCalendarIdentifiers: Set<Calendar.Identifier>? = nil,
        defaultTimeZones: Set<TimeZones>? = nil
    ) {
        device = Self.loadDevice()
        enableDevices = defaultDevices ?? Self.loadEnableDevices() ?? devicePresets
        enableLocales = defaultLocaleIdentifiers ?? Self.loadEnableLocales() ?? localeIdentifierPresets
        enableCalendars = defaultCalendarIdentifiers ?? Self.loadEnableCalendars() ?? calendarIdentifierPresets
        enableTimeZones = defaultTimeZones ?? Self.loadEnableTimeZones() ?? timeZonePresetes
    }

    private func saveDevice() {
        if let rawValue = device?.id {
            UserDefaults.standard.set(rawValue, forKey: "\(storageKeyPrefix).deviceID")
        } else {
            UserDefaults.standard.removeObject(forKey: "\(storageKeyPrefix).deviceID")
        }
    }

    private static func loadDevice() -> Device? {
        if let rawValue = UserDefaults.standard.string(forKey: "\(storageKeyPrefix).deviceID") {
            return Device(id: rawValue)
        } else {
            return nil
        }
    }

    private func saveEnableDevices() {
        let rawValues = Array(enableDevices.map(\.id))
        UserDefaults.standard.set(rawValues, forKey: "\(storageKeyPrefix).enableDevices")
    }

    private static func loadEnableDevices() -> Set<Device>? {
        if let rawValues = UserDefaults.standard.stringArray(forKey: "\(storageKeyPrefix).enableDevices") {
            return Set(rawValues.compactMap { Device(id: $0) })
        } else {
            return nil
        }
    }

    private func saveEnableLocales() {
        UserDefaults.standard.set(Array(enableLocales), forKey: "\(storageKeyPrefix).enableLocales")
    }

    private static func loadEnableLocales() -> Set<String>? {
        if let identifiers = UserDefaults.standard.stringArray(forKey: "\(storageKeyPrefix).enableLocales") {
            return Set(identifiers)
        } else {
            return nil
        }
    }

    private func saveEnableCalendars() {
        UserDefaults.standard.set(Array(enableCalendars.map(\.rawValue)), forKey: "\(storageKeyPrefix).enableCalendars")
    }

    private static func loadEnableCalendars() -> Set<Calendar.Identifier>? {
        if let rawValues = UserDefaults.standard.stringArray(forKey: "\(storageKeyPrefix).enableCalendars") {
            return Set(rawValues.compactMap(Calendar.Identifier.init))
        } else {
            return nil
        }
    }

    private func saveEnableTimeZones() {
        let rawValues = Array(enableTimeZones.map(\.rawValue))
        UserDefaults.standard.set(rawValues, forKey: "\(storageKeyPrefix).enableTimeZones")
    }

    private static func loadEnableTimeZones() -> Set<TimeZones>? {
        if let rawValues = UserDefaults.standard.stringArray(forKey: "\(storageKeyPrefix).enableTimeZones") {
            return Set(rawValues.compactMap { TimeZones(rawValue: $0) })
        } else {
            return nil
        }
    }
}
