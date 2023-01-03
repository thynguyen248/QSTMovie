//
//  Persistence.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 12/29/22.
//

import CoreData
import Combine

class CoreDataStack {
    static let shared = CoreDataStack()
    
//    static var preview: CoreDataStack = {
//        let result = CoreDataStack(inMemory: true)
//        let viewContext = result.container.viewContext
//        for _ in 0..<10 {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//        }
//        do {
//            try viewContext.save()
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        return result
//    }()
    
    private let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "QSTMovie")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            self.container.viewContext.automaticallyMergesChangesFromParent = true
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    private var mainContext: NSManagedObjectContext {
        container.viewContext
    }
    
    private lazy var newBackgroundContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        context.undoManager = nil
        return context
    }()
}

extension CoreDataStack {
    func fetch<T: NSManagedObject>(objectType: T.Type,
                                   predicate: NSPredicate? = nil,
                                   sortDescriptor: NSSortDescriptor? = nil,
                                   limit: Int? = nil)
    -> AnyPublisher<[T], AppError> {
        return Future() { [weak self] promise in
            let request = objectType.fetchRequest()
            request.predicate = predicate
            if let sortDescriptor = sortDescriptor {
                request.sortDescriptors = [sortDescriptor]
            }
            if let limit = limit {
                request.fetchLimit = limit
            }
            let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: request) { result in
                guard let result = result.finalResult as? [T] else { return }
                DispatchQueue.main.async {
                    promise(.success(result))
                }
            }
            do {
                try self?.mainContext.execute(asynchronousFetchRequest)
            } catch {
                promise(.failure(AppError.dbFetchError(error.localizedDescription)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func save<T: NSManagedObject>(objectType: T.Type, objects: [T]) -> AnyPublisher<Bool, AppError> {
        return Future() { promise in
            let context = objects.first?.managedObjectContext
            context?.performAndWait {
                if context?.hasChanges == true {
                    do {
                        try context?.save()
                        promise(.success((true)))
                    } catch {
                        promise(.failure(AppError.dbInsertError(error.localizedDescription)))
                    }
                } else {
                    promise(.success((false)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func publisher<T: NSManagedObject>(for managedObject: T,
                                       in context: NSManagedObjectContext,
                                       changeTypes: [ChangeType]) -> AnyPublisher<(object: T?, type: ChangeType), Never> {
        
        let notification = NSManagedObjectContext.didMergeChangesObjectIDsNotification
        return NotificationCenter.default.publisher(for: notification, object: context)
            .compactMap({ notification in
                for type in changeTypes {
                    if let object = self.managedObject(with: managedObject.objectID, changeType: type,
                                                       from: notification, in: context) as? T {
                        return (object, type)
                    }
                }
                
                return nil
            })
            .eraseToAnyPublisher()
    }
    
    func managedObject(with id: NSManagedObjectID, changeType: ChangeType,
                       from notification: Notification, in context: NSManagedObjectContext) -> NSManagedObject? {
      guard let objects = notification.userInfo?[changeType.userInfoKey] as? Set<NSManagedObjectID>,
            objects.contains(id) else {
        return nil
      }
      return context.object(with: id)
    }
}

extension CoreDataStack: DBHandlerProtocol {
    func fetchMovieList(predicate: NSPredicate?, sortType: SortType?, limit: Int?) -> AnyPublisher<[MovieModel], AppError> {
        let sortDescriptor: NSSortDescriptor?
        switch sortType {
        case .title:
            sortDescriptor = NSSortDescriptor(key: #keyPath(MovieMO.title), ascending: true)
        case .releasedDate:
            sortDescriptor = NSSortDescriptor(key: #keyPath(MovieMO.releasedDate), ascending: false)
        case .none:
            sortDescriptor = nil
        }
        return fetch(objectType: MovieMO.self, predicate: predicate, sortDescriptor: sortDescriptor, limit: limit)
            .map { $0.map { $0.movieModel } }
            .eraseToAnyPublisher()
    }
    
    func saveMovieList(movieList: [MovieModel]) -> AnyPublisher<[MovieModel], AppError> {
        let context = newBackgroundContext
        var movieMOs: [MovieMO] = []
        for model in movieList {
            let mo = MovieMO(context: context)
            mo.update(with: model)
            movieMOs.append(mo)
        }
        return save(objectType: MovieMO.self, objects: movieMOs)
            .map { result in
                return result ? movieList : []
            }
            .eraseToAnyPublisher()
    }
    
    func addRemoveFromWatchList(movieId: String, add: Bool) -> AnyPublisher<Bool, AppError> {
        return fetch(objectType: MovieMO.self, predicate: NSPredicate(format: "identifier = %@", movieId))
            .flatMap { [weak self] movieMOs -> AnyPublisher<Bool, AppError> in
                movieMOs.first?.inWatchList = add
                return self?.save(objectType: MovieMO.self, objects: movieMOs) ?? Empty().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
