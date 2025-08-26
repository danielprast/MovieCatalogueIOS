//
//  CoreDataPersistent.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 26/08/25.
//

import Foundation
import CoreData
import BZUtil


public actor CoreDataPersistent: MovieLocalDataSource {

  private let persistentContainer: NSPersistentContainer
  private let moc: NSManagedObjectContext

  public init() {
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

    moc = persistentContainer.viewContext
    moc.automaticallyMergesChangesFromParent = true
    moc.mergePolicy = NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType
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

    public func fetchMovies() async throws -> [MovieCoreData] {
      try await withCheckedThrowingContinuation { [persistentContainer] continuation in
        let request = MovieCoreData.fetchRequest()
        request.sortDescriptors = [
          NSSortDescriptor(keyPath: \MovieCoreData.title, ascending: true)
        ]
        do {
          let entities = try persistentContainer.viewContext.fetch(request)
          continuation.resume(with: .success(entities))
        } catch {
          let failure = MError.custom("Failed to fetch MovieCoreData entities. Reason: \(error.localizedDescription)")
          continuation.resume(throwing: failure)
        }
      }
    }

  // MARK: - • Movie Local Data Source

  public func save(movies: [any MovieEntity]) async throws -> Bool {
    return try await saveBatchData(movies)
  }

  public func loadMovies() async throws -> [any MovieEntity] {
    do {
      let movieEntities = try await fetchMovies()
      return movieEntities.map {
        let dto = $0.makeMovieRemoteDTO()
        return MovieEntityModel.mapFromMovieRemoteDTO(dto)
      }
    } catch {
      throw (error as! MError)
    }
  }

  public func searchMovies(for title: String) async throws -> [any MovieEntity] {
    return try await withCheckedThrowingContinuation { [persistentContainer] continuation in
      let moc = persistentContainer.viewContext
      let fetchRequest = MovieCoreData.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "title == %i", title)
      do {
        let entities = try moc.fetch(fetchRequest)
        let movies = entities.map {
          let dto = $0.makeMovieRemoteDTO()
          return MovieEntityModel.mapFromMovieRemoteDTO(dto)
        }
        continuation.resume(with: .success(movies))
      } catch {
        let failure = MError.custom("Failed to fetch MovieCoreData entities. Reason: \(error.localizedDescription)")
        continuation.resume(throwing: failure)
      }
    }
  }

  // MARK: - •

  var viewContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }

  func newBackgroundContext() -> NSManagedObjectContext {
    return persistentContainer.newBackgroundContext()
  }

  public func saveBatchData(_ items: [any MovieEntity]) async throws -> Bool {
    return try await withCheckedThrowingContinuation { [persistentContainer] continuation in
      persistentContainer.viewContext.performAndWait {
        do {
          try self.processBatch(items: items, in: persistentContainer.viewContext)

          if persistentContainer.viewContext.hasChanges {
            try persistentContainer.viewContext.save()
          }

          continuation.resume(with: .success(true))
        } catch {
          persistentContainer.viewContext.rollback()
          continuation.resume(throwing: error)
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
    entity.setValue(data.metadata, forKey: "metadata")
    entity.setValue(Date(), forKey: "updatedAt")
  }

  private func createNewEntity(
    with data: any MovieEntity,
    in context: NSManagedObjectContext
  ) {
    let newEntity = MovieCoreData(context: context)
    newEntity.setValue(data.id, forKey: "id")
    newEntity.setValue(data.title, forKey: "title")
    newEntity.setValue(data.metadata, forKey: "metadata")
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


extension CoreDataPersistent {

  private func llog(
    _ key: String,
    _ value: Any,
    type: TLogType = .info,
    subsystem: String = "module",
    file: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    clog(
      "\(Self.self) ≈ \(key)",
      value,
      type: type,
      subsystem: subsystem,
      file: file,
      function: function,
      line: line
    )
  }
}
