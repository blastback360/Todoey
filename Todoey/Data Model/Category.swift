//
//  Category.swift
//  Todoey
//
//  Created by Nimat Azeez on 5/2/19.
//  Copyright © 2019 Nimat Azeez. All rights reserved.
//

import Foundation
import RealmSwift

//"Category" class subclasses the "Object" class which is used to define Realm model objects
//Each "Category" has a one to many relationship with a list of "Items"
class Category: Object {

//When using Realm, variables must be marked with "@objc dynamic"; "dynamic" is declaration modifier that allows Realm to monitor for changes
    @objc dynamic var name: String = ""

    //Creation of a constant named "Items" that holds a "List" of Item objects initialized as an empty "List"; "List" is a container type
    //Defines the forward relationship; inside each "Category" there's something called "items" that points to a List of "Item" objects
    let items = List<Item>()
}
