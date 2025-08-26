//
//  MovieCoreData.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 26/08/25.
//

import Foundation
import BZUtil
@preconcurrency import CoreData


@objc(MovieCoreData)
public class MovieCoreData: NSManagedObject, Identifiable {
  @NSManaged public var id: String
  @NSManaged public var title: String
  @NSManaged public var metadata: String
}


extension MovieCoreData {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCoreData> {
    return NSFetchRequest<MovieCoreData>(entityName: "MovieCoreData")
  }
}


extension MovieCoreData {

  public func makeMovieRemoteDTO() -> MovieResponse.Result {
    guard
      let data = JsonResolver.createData(fromString: metadata),
      let dto = JsonResolver.decodeJson(
        from: data,
        outputType: MovieResponse.Result.self
      )
    else {
      return .makeEmpty()
    }
    return dto
  }
}


public actor CoreDataManager {

  private let persistentContainer: NSPersistentContainer
  private let context: NSManagedObjectContext

  private init() {
    persistentContainer = NSPersistentContainer(
      name: Self.modelName,
      managedObjectModel: CoreDataManager.managedObjectModel
    )

    let description = persistentContainer.persistentStoreDescriptions.first
    description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
    description?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

    persistentContainer.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Failed to load CoreData stores: \(error.localizedDescription)")
      }
    }

    context = persistentContainer.viewContext
    context.automaticallyMergesChangesFromParent = true
    context.mergePolicy = NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType
  }

  public static let modelName = "MovieCoreDataModel"

  public static let managedObjectModel: NSManagedObjectModel = {
    let bundle = Bundle.module
    let modelURL = bundle.url(
      forResource: modelName,
      withExtension: ".momd"
    )!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()

  //  private func performBackgroundTask<T>(
  //    _ block: @escaping (NSManagedObjectContext) throws -> T
  //  ) async throws -> T {
  //    try await withCheckedThrowingContinuation { continuation in
  //      container.performBackgroundTask { context in
  //        context.mergePolicy = NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType
  //
  //        do {
  //          let result = try block(context)
  //          continuation.resume(returning: result)
  //        } catch {
  //          continuation.resume(throwing: error)
  //        }
  //      }
  //    }
  //  }

  //  public func fetchMovies() async throws -> [MovieCoreData] {
  //    try await performBackgroundTask { context in
  //      let request = MovieCoreData.fetchRequest()
  //      request.sortDescriptors = [
  //        NSSortDescriptor(keyPath: \MovieCoreData.title, ascending: true)
  //      ]
  //      return try context.fetch(request)
  //    }
  //  }

  var viewContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }

  func newBackgroundContext() -> NSManagedObjectContext {
    return persistentContainer.newBackgroundContext()
  }

  public func saveBatchData(_ items: [any MovieEntity]) async throws {
    Task {
      try await withCheckedThrowingContinuation { continuation in
        let context = newBackgroundContext()

        context.perform {
          do {
            // Process batch with duplicate handling
            try self.processBatch(items: items, in: context)

            // Save changes
            if context.hasChanges {
              try context.save()
            }

            continuation.resume()
          } catch {
            context.rollback()
            continuation.resume(throwing: error)
          }
        }
      }
    }
  }

  private func processBatch(
    items: [any MovieEntity],
    in context: NSManagedObjectContext
  ) throws {
    // 1. Fetch existing items to check for duplicates
    let existingItems = try fetchExistingItems(ids: items.map { $0.id }, in: context)

    // 2. Create a dictionary for quick lookup
    var existingItemsDict: [String: MovieCoreData] = [:]
    existingItems.forEach { item in
      if let itemId = item.value(forKey: "id") as? String {
        existingItemsDict[itemId] = item
      }
    }

    // 3. Process each item
    for itemData in items {
      if let existingItem = existingItemsDict[itemData.id] {
        // Update existing item
        updateEntity(existingItem, with: itemData)
      } else {
        // Create new item
        createNewEntity(with: itemData, in: context)
      }
    }

    // 4. Optional: Delete items not in the new batch (if needed)
    // try deleteMissingItems(from: existingItems, keeping: items.map { $0.id }, in: context)
  }

  private func fetchExistingItems(
    ids: [String],
    in context: NSManagedObjectContext
  ) throws -> [MovieCoreData] {
    let fetchRequest: NSFetchRequest<MovieCoreData> = MovieCoreData.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)

    return try context.fetch(fetchRequest)
  }

  private func updateEntity(
    _ entity: MovieCoreData,
    with data: any MovieEntity
  ) {
    entity.setValue(data.title, forKey: "title")
    entity.setValue(data.description, forKey: "metadata")
    entity.setValue(Date(), forKey: "updatedAt")
  }

  private func createNewEntity(
    with data: any MovieEntity,
    in context: NSManagedObjectContext
  ) {
    let newEntity = MovieCoreData(context: context)
    newEntity.setValue(data.id, forKey: "id")
    newEntity.setValue(data.title, forKey: "title")
    newEntity.setValue(data.description, forKey: "metadata")
    newEntity.setValue(Date(), forKey: "createdAt")
    newEntity.setValue(Date(), forKey: "updatedAt")
  }

  // Optional: Delete items that are not in the new batch
  private func deleteMissingItems(
    from existingItems: [MovieCoreData],
    keeping idsToKeep: [String],
    in context: NSManagedObjectContext
  ) throws {
    let itemsToDelete = existingItems.filter { item in
      guard let itemId = item.value(forKey: "id") as? String else { return false }
      return !idsToKeep.contains(itemId)
    }

    for item in itemsToDelete {
      context.delete(item)
    }
  }
}
