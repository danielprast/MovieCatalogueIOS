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

  private let persistentContainer: MSCoreDataContainer
  private let moc: NSManagedObjectContext

  public init() {
    persistentContainer = MSCoreDataContainer(
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

  public func fetchMovies() async throws -> [MovieCoreData] {
    try await withCheckedThrowingContinuation { [persistentContainer] continuation in
      persistentContainer.createNewBackgroundContext()
      let context = persistentContainer.backgroundContext
      let request = MovieCoreData.fetchRequest()
      request.sortDescriptors = [
        NSSortDescriptor(keyPath: \MovieCoreData.title, ascending: true)
      ]
      do {
        let entities = try context.fetch(request)
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
      persistentContainer.createNewBackgroundContext()
      let context = persistentContainer.backgroundContext
      let fetchRequest = MovieCoreData.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "title CONTAINS %@", title)
      do {
        let entities = try context.fetch(fetchRequest)
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

  public func saveBatchData(_ items: [any MovieEntity]) async throws -> Bool {
    return try await withCheckedThrowingContinuation { [persistentContainer] continuation in
      persistentContainer.createNewBackgroundContext()
      let taskContext = persistentContainer.backgroundContext
      taskContext.name = "saveBatchMovies"
      taskContext.transactionAuthor = "saveMovies"
      taskContext.performAndWait {
        let context = persistentContainer.backgroundContext
        do {
          try self.processBatch(
            items: items,
            in: context
          )

          if context.hasChanges {
            try context.save()
            llog("context saved", "!!!")
          }

          continuation.resume(with: .success(true))
        } catch {
          context.rollback()
          continuation.resume(throwing: error)
        }
      }
    }
  }

  private func processBatch(
    items: [any MovieEntity],
    in context: NSManagedObjectContext
  ) throws {
    let existingItems = try fetchExistingItems(ids: items.map { $0.id }, in: context)

    var existingItemsDict: [String: MovieCoreData] = [:]
    existingItems.forEach { item in
      if let itemId = item.value(forKey: "id") as? String {
        existingItemsDict[itemId] = item
      }
    }

    for itemData in items {
      if let existingItem = existingItemsDict[itemData.id] {
        updateEntity(existingItem, with: itemData)
      } else {
        createNewEntity(with: itemData, in: context)
      }
    }
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

// MARK: - •

public final class MSCoreDataContainer: NSPersistentContainer, @unchecked Sendable {

  private var _backgroundContext: NSManagedObjectContext?
  public var backgroundContext: NSManagedObjectContext {
    _backgroundContext!
  }

  public func createNewBackgroundContext() {
    let context = newBackgroundContext()
    _backgroundContext = context
  }

}
