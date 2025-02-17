//
//  Persistence.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 27/4/24.
//
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TrainingLocation")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func addFavoriteEvent(eventId: UUID) {
        let context = container.viewContext
        let newFavorite = FavoriteEvents(context: context)
        newFavorite.id = eventId
        saveContext()
    }

    func removeFavoriteEvent(eventId: UUID) {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<FavoriteEvents> = FavoriteEvents.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", eventId as CVarArg)

        do {
            let results = try context.fetch(fetchRequest)
            if let favorite = results.first {
                context.delete(favorite)
                saveContext()
            }
        } catch {
            print("Failed to fetch FavoriteEvents: \(error)")
        }
    }

    func isEventFavorite(eventId: UUID) -> Bool {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<FavoriteEvents> = FavoriteEvents.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", eventId as CVarArg)

        do {
            let results = try context.fetch(fetchRequest)
            return results.first != nil
        } catch {
            print("Failed to fetch FavoriteEvents: \(error)")
            return false
        }
    }
}

