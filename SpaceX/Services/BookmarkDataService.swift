//
//  BookmarkDataService.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/30/23.
//

import Foundation
import CoreData



class BookmarkDataService {
    
    static let shared = BookmarkDataService() // Singleton
    
    private let container: NSPersistentContainer
    private let containerName: String = "BookmarkContainer"
    private let entityName: String = "BookmarkEntity"
    
    @Published var savedEntities: [BookmarkEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data , by the error : \(error)")
            }
        }
        getBookmark()
    }
    
    //MARK: Public
    func updateBookmark(launch: Launch) {
        if let entity = savedEntities.first(where: { $0.id == launch.id }) {
            removeBookmark(entity: entity)
        } else {
            addBookmark(launch: launch)
        }
    }
    
    //MARK: Private
    private func getBookmark() {
        let request = NSFetchRequest<BookmarkEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching the bookmakr entities , error : \(error)")
        }
    }
    
    private func addBookmark(launch: Launch) {
        
        let entity = BookmarkEntity(context: container.viewContext)
        
        entity.id = launch.id
        entity.flightNumber = Int64(launch.flightNumber)
        entity.success = launch.success!
        applyChanges()
        
    }
    
    private func removeBookmark(entity: BookmarkEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getBookmark()
    }
    
    
    
    
}
