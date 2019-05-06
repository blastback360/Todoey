//
//  Item.swift
//  Todoey
//
//  Created by Nimat Azeez on 5/2/19.
//  Copyright © 2019 Nimat Azeez. All rights reserved.
//

import Foundation
import RealmSwift

//"Item" class subclasses the "Object" class which is used to define Realm model objects
//Each "Item" has an inverse relationship to a category called the "parentCategory"
class Item: Object {
    
    //When using Realm, variables must be marked with "@objc dynamic"; "dynamic" is declaration modifier that allows Realm to monitor for changes
    @objc dynamic var title: String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    
    //Setting the inverse relationship "parentCategory" to an object of the class "LinkingObjects"; "LinkingObjects" represent zero or more objects that are linked to its owning model object through a property relationship
    //Property that needs to be specified is the name of the forward relationship which is "items"
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
