//
//  ShuttlesViewModel.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/27/23.
//

import Foundation
import SwiftUI
import Combine



class ShuttleViewModel: ObservableObject  {
    
    
    private var requestManager = RequestManager.shared
    private let bookmarkDataService = BookmarkDataService()
    private let launchesDataSource = LaunchesDataSource.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var alllaunches = [Doc]()
    @Published private(set) var filteredLaunches = [Doc]()
    @Published private(set) var bookmarkLaunches = [Doc]()
    @Published private(set) var isLoading = false
    @Published private(set) var isShwoingLaunchScreen = true
    @Published var hasError = false
    @Published var searchText = ""
    
    var upcoming = false
    var limit = 20
    var pageNumber = 1
    var sort = "desc"

    init() {
        addSubscribers()
        
    }

    func addSubscribers() {
        $searchText
            .combineLatest(self.$alllaunches)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map (filterShuttleListBySearch)
            .sink { [weak self] returnedLaunches in
                self?.filteredLaunches  = returnedLaunches
            }
            .store(in: &cancellables)

        $alllaunches
            .combineLatest(bookmarkDataService.$savedEntities)
            .map(filterLaunchesBySavedEntities)
            .sink { [weak self] (returnedBoormarks) in
                self?.bookmarkLaunches = returnedBoormarks
            }
            .store(in: &cancellables)
    }
    
    //MARK: Model
    @MainActor
    func getLaunches() async {
        guard alllaunches.isEmpty else {
            return
        }

        isLoading = true
        hasError = false
        defer { isLoading = false }
        do {
            let result: Welcome = try await requestManager.perform(GetMissions.getMissionsWith(upcoming: upcoming, limit: limit, pageNumber: pageNumber, sort: sort))
            
            if let docs = result.docs {
                for doc in docs {
                    self.alllaunches.append(doc)
                }
                launchesDataSource.alllaunches = alllaunches
            }
        }
        catch {
            #if DEBUG
            print("Cannot parse data")
            print("Decoding error:" , error)
            #endif
            hasError = true
        }
    }
    
    @MainActor
    func getNextSetOfLaunches() async {
        
        pageNumber += 1
        do {
            let result: Welcome = try await requestManager.perform(GetMissions.getMissionsWith(upcoming: upcoming, limit: limit, pageNumber: pageNumber, sort: sort))
            
            if let docs = result.docs {
                for doc in docs {
                    self.alllaunches.append(doc)
                }
                launchesDataSource.alllaunches = alllaunches
            }
        }
        catch {
            print("Cannot parse data")
            print("Decoding error:" , error)
        }
    }

    func getSucessColor(with launch: Doc) -> Color {
        if  launch.success! {
           return Color.green
        } else if !launch.success! {
           return Color.red
       }
       return Color.blue
   }
    
    func getWekipediaLink(with launch: Doc) -> String? {
        if let links = launch.links, let wekipediaLink = links.wikipedia {
            return wekipediaLink
        }
        return nil
    }
    
    func getMissionImageUrls(with launch: Doc) -> [String] {
        guard let originalImageUrls = launch.links?.flickr?.original , originalImageUrls.count != 0  else {
            // Handle the case when `originalImageUrls` is nil
            return ["https://startupmagazine.dk/wp-content/uploads/2021/05/SpaceX-logo.jpg"]
        }
    return originalImageUrls
}
    
    func checkIsBookmarked(launch: Doc) -> Bool {
        bookmarkLaunches.contains { $0.id == launch.id }
    }
    
    func getSuccessStatus(with launch: Doc) -> String {
        if launch.success! {
            return "Successfull"
        } else {
            return "Failed"
        }
    }
    
    func dismissLaunchScreen() {
        isShwoingLaunchScreen = false
    }
    
    //MARK: Intent(s)
    func checkIfHasReachedEnd(with launch: Doc) -> Bool {
        alllaunches.last?.id == launch.id
    }

    func updateBookmark(launch: Doc) {
        bookmarkDataService.updateBookmark(launch: launch)
    }
    
    func searchShuttles(with searchText: String) async  {
        do {
            let result: Welcome = try await requestManager.perform(SearchMissions.getMissionsWith(upcoming: upcoming, limit: 20, pageNumber: 1, sort: "desc", searchText: searchText))
            print("Real time search result: \(result.docs!.count)")
        } catch let error {
            print(error)
        }
    }

    private func filterShuttleListBySearch(searchText: String, launches: [Doc]) -> [Doc] {
        
        guard !searchText.isEmpty else {
            return launches
        }
        
        let lowercaseText = searchText.lowercased()
        
        let filteredLaunches = launches.filter { launch in
            return launch.name.lowercased().contains(lowercaseText)
        }
        
        return filteredLaunches

    }
    
    private func filterLaunchesBySavedEntities(launchModels: [Doc], bookmarkEntities: [BookmarkEntity]) -> [Doc] {
        launchModels
            .compactMap { launch in
                guard bookmarkEntities.first(where: { $0.id == launch.id }) != nil else {
                    // If there's no bookmark found
                    return nil
                }
                return launch
            }
    }

}