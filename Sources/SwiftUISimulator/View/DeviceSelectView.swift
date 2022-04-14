//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import SwiftUI

struct DeviceSelectView: View {
    // 💡 iOS 15+: \.dismiss
    @Environment(\.presentationMode) var presentationMode

    private let selectedDevices: Binding<Set<Device>>

    init(selectedDevices: Binding<Set<Device>>) {
        self.selectedDevices = selectedDevices
    }

    var body: some View {
        NavigationView {
            List(selection: selectedDevices) {
                //
                // 💡 iOS 15+
                //
                // `Section("xxx") { ... }`
                // https://developer.apple.com/documentation/swiftui/section/init(_:content:)-90be4
                //
                Section {
                    ForEach(Device.iPhones, id: \.name) { device in
                        row(device: device).tag(device)
                    }
                } header: {
                    HStack {
                        Text("iPhone")
                        Spacer()
                        Button("Select All") {
                            selectedDevices.wrappedValue = selectedDevices.wrappedValue.union(Device.iPhones)
                        }
                    }
                }

                Section {
                    ForEach(Device.iPads, id: \.name) { device in
                        row(device: device).tag(device)
                    }
                } header: {
                    HStack {
                        Text("iPad")
                        Spacer()
                        Button("Select All") {
                            selectedDevices.wrappedValue = selectedDevices.wrappedValue.union(Device.iPads)
                        }
                    }
                }
            }
            .environment(\.editMode, .constant(.active))
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(selectedDevices.wrappedValue.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Clear") {
                        selectedDevices.wrappedValue = []
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func row(device: Device) -> some View {
        let size = device.size(orientation: .portrait)
        HStack {
            Text("\(device.name) (\(device.inch) inch)")
            Spacer()
            Text("\(Int(size.width)) x \(Int(size.height))")
        }
    }
}
