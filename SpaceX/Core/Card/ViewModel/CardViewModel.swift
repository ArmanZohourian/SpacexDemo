//
//  CardViewModle.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/28/23.
//

import Foundation
import SwiftUI

class CardViewModel: ObservableObject {
    
    let launch: Launch
    
    init(launch: Launch) {
        self.launch = launch
    }
    
    var launchStatus: String {
        getSuccessStatus(with: launch)
    }
    
    var launchStatusColor: Color {
        getSucessColor(with: launch)
    }
    
    var launchLogoUrl: String {
        getImageUrl(with: launch)
    }
    
    var launchDate: String {
        formatDate(launch.dateLocal)
    }
    
    private func getSuccessStatus(with launch: Launch) -> String {
        if let successStatus = launch.success {
            if successStatus {
                return "Successfull"
            } else {
                return "Failed"
            }
        }
        return "Cancelled"
    }
    
    private func getSucessColor(with launch: Launch) -> Color {
        if let successStatus = launch.success {
            if  successStatus {
                return Color.green
            } else {
                return Color.red
            }
        }
        return Color.blue
}
    
    private func getImageUrl(with launch: Launch) -> String {
        if let links = launch.links {
            if let patch = links.patch {
                if let smallPatchUrlString = patch.small {
                    return smallPatchUrlString
                }
            }
        }
        return ""
    }
    
    private func formatDate(_ dateString: String) -> String {

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        if let date = isoFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy"
            return formatter.string(from: date).uppercased()
        } else {
            return ""
        }
    }
}
