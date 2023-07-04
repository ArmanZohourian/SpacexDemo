//
//  DetailViewModel.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/28/23.
//

import Foundation
import SwiftUI
import Combine


class DetailViewModel: ObservableObject {
    
    private let bookmarkDataService = BookmarkDataService.shared
    private let launchesDataSource = LaunchesDataSource.shared
    private let requestManager = RequestManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var bookmarkLaunches = [Doc]()
    @Published private(set) var launchCrewMembers = [CrewMember]()
    @Published var launch: Doc
    
    init(launch: Doc) {
        
        self.launch = launch
        self.addSubscribers()
        Task {
        for launchCrewMember in launch.crew {
                await fetchCrewMembers(launchCrew: launchCrewMember)
            }
        }
    }
    
    
    var launchDescription: String? {
        launch.details
    }
    
    var successStatus: String {
        getSuccessStatus(with: launch)
    }
    
    var wikipediaLink: String? {
        getWekipediaLink(with: launch)
    }
    
    var date: String {
        formatDate(launch.dateLocal)
    }
    
    //MARK: Model
    func addSubscribers() {
        launchesDataSource.$alllaunches
            .combineLatest(bookmarkDataService.$savedEntities)
            .map (filterLaunchesByEntities)
        
            .sink { [weak self] (returnedBoormarks) in
                self?.bookmarkLaunches = returnedBoormarks
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func fetchCrewMembers(launchCrew: Crew) async {
        do {
            let crew: CrewMember = try await requestManager.perform(GetCrews.byCrewId(crewId: launchCrew.crew))
            launchCrewMembers.append(crew)
            print("Launch crew members are : \(launchCrewMembers)")
        } catch let error {
            print(error)
        }
    }
    
    func checkIsBookmarked(launch: Doc) -> Bool {
        bookmarkLaunches.contains { $0.id == launch.id }
    }
    
    private func getSuccessStatus(with launch: Doc) -> String {
        if let successStatus = launch.success {
            if successStatus {
                return "Successfull"
            } else {
                return "Failed"
            }
        }
        return "Cancelled"
    }
    
    private func getWekipediaLink(with launch: Doc) -> String? {
        if let links = launch.links, let wekipediaLink = links.wikipedia {
            return wekipediaLink
        }
        return nil
    }
    
    private func formatDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        if let date = isoFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy"
            return formatter.string(from: date)
        } else {
            return ""
        }
    }
    
    func getMissionImageUrls(with launch: Doc) -> [String] {
        guard let originalImageUrls = launch.links?.flickr?.original , originalImageUrls.count != 0  else {
            // Handle the case when `originalImageUrls` is nil
            return ["https://startupmagazine.dk/wp-content/uploads/2021/05/SpaceX-logo.jpg"]
        }
    return originalImageUrls
}
    
    private func filterLaunchesByEntities(launches: [Doc], bookmarkEntities: [BookmarkEntity]) -> [Doc] {
        launches
            .compactMap { launch in
                guard bookmarkEntities.first(where: { $0.id == launch.id }) != nil else {
                    return nil
                }
                return launch
            }
    }
    
    //MARK: Intent(s)
    func updateBookmark(launch: Doc) {
        bookmarkDataService.updateBookmark(launch: launch)
    }
    
    
    
}
