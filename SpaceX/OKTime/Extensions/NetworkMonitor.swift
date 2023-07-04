//
//  NetworkConnection.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/23/22.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()

    
    @Published var isConnected = false
    
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    let queue = DispatchQueue(label: "NetworkMonitor")

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                
                print("We're connected!")
                self?.isConnected = true
                
                // post connected notification
            } else {
                
                print("No connection.")
                self?.isConnected = false
                // post disconnected notification
            }
            print(path.isExpensive)
        }

        
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
