//
//  CoreDataStack.swift
//  BigCore
//
//  Created by Sukumar Anup Sukumaran on 03/06/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation
import CoreData
import SASLogger

public class CoreDataStack {
    
    // MARK: - Core Data stack
    
    private init() {}
    
    @available(iOS 10.0, *)
    public static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    @available(iOS 10.0, *)
    public static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "HitList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               Logger.p("persistentContainer - Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    @available(iOS 10.0, *)
    public static  func saveContext (comp: (() -> ())? = nil) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                comp?()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                Logger.p("saveContext - nserror = \(nserror)")
            }
        }
    }
    
    @available(iOS 10.0, *)
    public static func fetchData(entityName: String) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        var data: [NSManagedObject]?
        do {
          data = try CoreDataStack.context.fetch(fetchRequest)
        } catch let error as NSError {
            Logger.p("fetchData - Could not fetch. \(error), \(error.userInfo)")
        }
        
        return data
    }
    
    
    @available(iOS 10.0, *)
    public static func save<T>(name: T,entityName: String,keyPath: String, comp: @escaping (_ data: NSManagedObject) -> ()) {

        let entity = NSEntityDescription.entity(forEntityName: entityName, in: CoreDataStack.context)!

        let data = NSManagedObject(entity: entity, insertInto: CoreDataStack.context)

        data.setValue(name, forKeyPath: keyPath)

        CoreDataStack.saveContext {
            comp(data)
        }

    }
    
    
}
