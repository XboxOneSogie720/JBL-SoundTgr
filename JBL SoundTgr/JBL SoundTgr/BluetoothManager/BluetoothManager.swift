//
//  BluetoothManager.swift
//  JBL SoundTgr
//
//  Created by Karson Eskind on 2/13/24.
//

import Foundation
import CoreBluetooth

final class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    //MARK: UUIDs
    private let jblServiceUuid        = CBUUID(string: "65786365-6C70-6F69-6E74-2E636F6D0000")
    private let jblCharacteristicUuid = CBUUID(string: "65786365-6C70-6F69-6E74-2E636F6D0002")
    
    
    //MARK: CoreBluetooth related objects
    private var centralManager: CBCentralManager?
    private var peripherals: [CBPeripheral] = []
    private var jblProduct: CBPeripheral?
    private var jblCharacteristic: CBCharacteristic?
    
    
    //MARK: Variables for the UI
    @Published var isActive    = false
    @Published var isConnected = false
    
    
    //MARK: Initializer for this class
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    
    //MARK: If the centralManager changed its state...
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isActive = true
            startScanning()
        } else {
            isActive = false
            print("centralManager is in an unknown state")
            peripherals.removeAll()
        }
    }
    
    
    //MARK: If the centralManager found a new peripheral...
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        /* If this is a new peripheral...*/
        if !peripherals.contains(peripheral) {
            print("Discovered new peripheral: \(getPeripheralName(peripheral: peripheral))")
            peripherals.append(peripheral)
            centralManager?.connect(peripheral)
        }
    }
    
    
    //MARK: If the centralManager successfully connected to a peripheral...
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        print("Connected to: \(getPeripheralName(peripheral: peripheral)), discovering services...")
    }
    
    
    //MARK: If the peripheral discovered services...
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("Error discovering services: \(String(describing: error?.localizedDescription))")
            return
        }
        
        guard let services = peripheral.services else {
            print("Error: No services found")
            return
        }
        
        var jblServiceFound = false
        
        for service in services {
            if service.uuid == jblServiceUuid {
                /* Discover characteristics */
                peripheral.discoverCharacteristics(nil, for: service)
                jblServiceFound = true
            }
        }
        
        if !jblServiceFound {
            /* This peripheral is no use to us, cancel its connection */
            centralManager?.cancelPeripheralConnection(peripheral)
            print("No JBL services discovered for: \(getPeripheralName(peripheral: peripheral))")
        }
    }
    
    
    //MARK: If the periphreal discovered characteristics...
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            print("Error discovering characteristics: \(String(describing: error?.localizedDescription))")
            return
        }
        
        guard let characteristics = service.characteristics else {
            print("Error: No characteristics found")
            return
        }
        
        for characteristic in characteristics {
            if characteristic.uuid == jblCharacteristicUuid {
                print("Found peripheral with JBL service and JBL characteristic: \(getPeripheralName(peripheral: peripheral))")
                jblProduct = peripheral
                jblCharacteristic = characteristic
                centralManager?.stopScan()
                isConnected = true
            }
        }
    }
    
    
    //MARK: If the centralManager disconnected from a peripheral...
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == jblProduct {
            isConnected = false
            startScanning()
            peripherals.removeAll()
        }
    }
    
    
    //MARK:
    func playSound() {
        /* If the write characteristic receives this data, it acts as a command to play a private sound stored on the speaker itself */
        let data = Data([0xAA, 0x31])
        jblProduct?.writeValue(data, for: jblCharacteristic! , type: .withResponse) // Typically you would not want to force unwrap your jblCharacteristic, but since in our app this function is only accessable if connected to a product, it's fine here
    }
    
    
    //MARK: Private functions/utilities
    private func startScanning() {
        centralManager?.scanForPeripherals(withServices: nil)
        print("centralManager has started scanning for peripherals")
    }
    
    
    private func getPeripheralName(peripheral: CBPeripheral) -> String {
        return peripheral.name ?? "<no name>"
    }
}
