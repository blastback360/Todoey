//
//  AppDelegate.swift
//  Todoey
//
//  Created by Nimat Azeez on 4/20/19.
//  Copyright © 2019 Nimat Azeez. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print (Realm.Configuration.defaultConfiguration.fileURL!) //Used to locate where our Realm database is
        
        do {
            let realm = try Realm() //Creation of a new object from the Realm class
//            try realm.write { //Commits the current state to our Realm database
//                realm.add(data) //Adds a new object of "data"
//            }
        } catch {
            print ("Error initializing new realm, \(error)")
        }
        return true
    }

    
}
