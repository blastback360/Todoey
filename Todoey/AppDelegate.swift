//
//  AppDelegate.swift
//  Todoey
//
//  Created by Nimat Azeez on 4/20/19.
//  Copyright © 2019 Nimat Azeez. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        //Statement that prints the file path to all the data saved using UserDefaults
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {

        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    //Lazy variables only gets loaded with a value when it's needed; get a memory benefit because of this
    //The NSPersistentContainer is where we will be storing all of our data; is a SQLite database
    lazy var persistentContainer: NSPersistentContainer = {
    
        let container = NSPersistentContainer(name: "DataModel") //This constant sets up this new persistent container; name must match the name of the Data Model
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving Support
    
    //Provides  support to saving our data when our app is terminated 
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
