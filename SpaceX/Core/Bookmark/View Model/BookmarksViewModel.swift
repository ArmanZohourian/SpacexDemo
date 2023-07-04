//
//  BookmarksViewModel.swift
//  SpaceX
//
//  Created by Arman Zohourian on 7/1/23.
//

import Foundation
import Combine

class BookmarksViewModel: ObservableObject {
    
    private let bookmarkDataService = BookmarkDataService.shared
    private let launchesDataSource = LaunchesDataSource.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var bookmarkLaunches = [Launch]()
    
    init() {
        addSubscribers()
    }
    
    //MARK: Model
    func addSubscribers() {
        launchesDataSource.$alllaunches
            .combineLatest(bookmarkDataService.$savedEntities)
            .map(filterLaunchesByEntities)
            .sink { [weak self] (returnedBoormarks) in
                self?.bookmarkLaunches = returnedBoormarks
            }
            .store(in: &cancellables)
    }
    
    private func filterLaunchesByEntities(launches: [Launch], bookmarkEntities: [BookmarkEntity]) -> [Launch] {
        launches
            .compactMap { launch in
                guard bookmarkEntities.first(where: { $0.id == launch.id }) != nil else {
                    return nil
                }
                return launch
            }
    }
}
