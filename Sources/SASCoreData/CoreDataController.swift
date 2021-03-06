//
//  File.swift
//  
//
//  Created by Sukumar Anup Sukumaran on 16/07/20.
//

import Foundation
import CoreData

@available(OSX 10.12, *)
@available(iOS 10.0, *)
public class DataController {
    
    public let persistentContainer: NSPersistentContainer
    
    public var viewContext: NSManagedObjectContext {
        
        return persistentContainer.viewContext
        
    }
    var loaded: Bool = false
    public var backgroundContext: NSManagedObjectContext!
    
    public init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    public func configureContexts() {
        backgroundContext = persistentContainer.newBackgroundContext()
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    public func load(completion:(() -> ())? = nil) {
        guard !loaded else {return}
        loaded = true
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else { fatalError("CoreDataError😳\(error!.localizedDescription)")}
            
            self.configureContexts()
            completion?()
        }
    }
    
    public func fetchDataWith(sortOrderKey: String, ascending: Bool, entityName: String) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: sortOrderKey, ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var data: [NSManagedObject]?
        do {
          data = try viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("newfetchData - fetchError - \(error.localizedDescription)")
        }
        
        return data
    }
    
    public func fetchData(entityName: String) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        var data: [NSManagedObject]?
        do {
          data = try viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("newfetchData - fetchError - \(error.localizedDescription)")
        }
        
        return data
    }
    
    public func saved() {
        if viewContext.hasChanges {
            do{
                try viewContext.save()
                
                print("Saved Pin😛")
            }catch let error{
                print(" Error😩 = \(error.localizedDescription)")
            }
        } else {
            print("No Changes in nsmanagedobjectcontext")
        }
        
    }
    
    public func deletedAndSave(_ data: NSManagedObject) {
        viewContext.delete(data)
        saved()
    }
    
}

public extension NSObject {
    
    static var entityName: String {
        String(describing: self)
    }
}
