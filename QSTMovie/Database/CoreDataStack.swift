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
            let request = NSFetchRequest<T>(entityName: String(describing: T.self))
            request.predicate = predicate
            if let sortDescriptor = sortDescriptor {
                request.sortDescriptors = [sortDescriptor]
            }
            if let limit = limit {
                request.fetchLimit = limit
            }
            let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: request) { result in
                let result = result.finalResult ?? []
                promise(.success(result))
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
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                movieMOs.first?.inWatchList = add
                return self.save(objectType: MovieMO.self, objects: movieMOs)
            }
            .eraseToAnyPublisher()
    }
}
