//
//  ViewController.swift
//  Todoey
//
//  Created by Nimat Azeez on 4/20/19.
//  Copyright © 2019 Nimat Azeez. All rights reserved.
//

import UIKit
import CoreData //To use NSManagedObjects

//View controller that specializes in managing a table view; UITableViewController is the superclass 
class ToDoListViewController: UITableViewController {

    var itemArray = [Item]() //Variable containing an array of NSManagedObjects created using the Item entity
    
    //Variable with a type of an optional "Category" entity; use of "didSet" which allows for code between blocks to be be run only after "selectedCategory" has been set to a value
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    //Creation of a file path to the documents folder; also creates a plist file named "Items.plist"
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //Tapping into the UIApplication class to get the shared singleton that corresponds to the current app and tapping into its delegate and downcasting it into our class AppDelegate to tap into its properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let defaults = UserDefaults.standard //Interface to the user's database, where you store key-value pairs persistently across launches of your app
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

    
    //MARK - Tableview Datasource Methods

    //Required tableView func that sets the amount of rows required for a particular tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count //Returns the number of rows
    }

    //Required tableView func that sets which cell to be used for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) //Setting cell with identifier created in prototype cell from the TableViewController
        
        let item = itemArray[indexPath.row] //The item that we are currently trying to set up for the cell
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    
    //tableView func that lets you know which row has been selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //itemArray[indexPath.row].setValue("New Title", forKey: "title"); Another way to update NSManagedObject (still have to call "context.save" after this)
        
        //context.delete(itemArray[indexPath.row]) //Removes data from the context; must be used first
        //itemArray.remove(at: indexPath.row) //Removes a value from an array at a certain index; must be used second
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //Updates the "done" property at a certain index path to the opposite value of the same "done" property at that same index path
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true) //Allows for tableView cells to be momentarily highlighted instead of continously highlighted
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Creation of a UIAlert that will pop-up whenever the Add button is pressed
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //What will happen when the user clicks the Add button in our UIAlert; is represented as the button in the UIAlert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //Item is our CoreData class; specifying the context where this item is going to exist; context is the view context of the persistentContainer in the AppDelegate
            let newItem = Item(context: self.context)
            newItem.title = textField.text! //Assigning newItem property "title" content from the textField
            newItem.done = false //Assigning newItem property "done" an intial value of false for every new item added
            newItem.parentCategory = self.selectedCategory //Used to determine which Category Todo list to open; avaliable because we created a relationship that points to the "Category" entity 
            
            self.itemArray.append(newItem) //Adds value of the textField to the end of the itemArray
            
            self.saveItems()
            
        }
        
        //Adding a textField to the UIAlert; "alertTextField" inside the completion handler is named by the programmer ... can be named something else
        alert.addTextField { (alertTextField) in

            alertTextField.placeholder = "Create new item" //Placeholder for the textField
            textField = alertTextField //Setting the textField variable the text from the alertTextField completion handler
        }
        
        alert.addAction(action) //Adding the action to the UIAlert
        
        present(alert, animated: true, completion: nil) //Code required to actually show alert
    }
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        
        do {
            try context.save() //Commits our context to permanent storage inside our persistentContainer
        } catch {
            print ("Error saving context \(error)")
        }
        
        tableView.reloadData() //Reloads the tableView
    }
    
    //"with" is the external parameter (parameter used when calling function) and "request" and "predicate" are the internal parameters (parameters used inside block of code)
    //" = Item.fetchRequest() " and " = nil " provide the parameters a default value; good if you nned to call the function without giving it any parameters or all neccasary parameters
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), with predicate: NSPredicate? = nil) {

        //Constant that fetches results in the form of Items and types into the Item entity to make a fetch request; must specify the data type and entity (Item) you are trying to request
        //let request: NSFetchRequest <Item> = Item.fetchRequest()
        
        //NSPredicate intialized with the format that the parent category of the items returning back must have its name property matching the current selected category name 
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //Use of optional binding to ensure that "predicate" is not nil
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate]) //Predicate for request is a compound predicate created using the "categoryPredicate" and the "additionalPredicate"
        } else {
            request.predicate = categoryPredicate //If "predicate" is nil, our request's predicate is simply go to be the "categoryPredicate"
        }
        
        do {
            itemArray = try context.fetch(request) //Setting the return of the method "context.fetch(request)" to "itemArray"; speaking with context is required to work in our persistent container
        } catch {
            print ("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK - SearchBar Delegate Methods

//Extends and splits up the functionality of the ToDoListViewController
//Good for making a current ViewController more modular and better organized
extension ToDoListViewController: UISearchBarDelegate {
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest() //Reading from the context; constant is of type "NSFetchRequest" and returns an array of "Item" and is set to equal "Item.fetchRequest()"

        //Modifying the request to tag on a query specifying what we want back from the database
        //Looks at the title of each item in the Item array and checks if it CONTAINS a value; the argument (i.e. searchBar.text!) replaces the " %@ " to be passed into the function
        //"[cd]" allows for it not to be case or diacritic sensitive
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //Functions exactly the same as code above, but format above is required for function call
        
        //Adds a "sortDescriptor" to our request
        //Sorts the data that we get back from the database; sorts using the key (i.e. "title") and arranges it in alphabetic order due to ascending being set to "true"
        //"sortDescriptors" expects an array of "NSSortDescriptor" so you must add brackets around right hand side
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, with: predicate)
        
    }
    
    //searchBar method that detetcts when text in the search bar has changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            //Assigns tasks to different threads; asking the DispatchQueue to get the main queue and run the code block on the main queue asynchronously
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() //Lets the seacrBar know that it should no longer be the thing that is currently selected
            }
        }
    }
}


//MARK - Model Manipulation Methods Using NSCoder
//    func saveItems() {
//
//        let encoder = PropertyListEncoder() //An object that encodes instances of data types to a property list
//
//        //Encoding and writing methods can throw an errors, so they must be put into a do-catch block
//        do {
//            let data = try encoder.encode(itemArray) //Encodes the itemArray into a property list
//            try data.write(to: dataFilePath!) //Writes data to our dataFilePath
//        } catch {
//            print("Error encoding item array, \(error)")
//        }
//
//        tableView.reloadData() //Reloads the tableView
//    }
//
//    func loadItems() {
//
//        //Taps into our data from our dataFilePath; may also throw an error so is marked with a "try?" and assigned to the data variable using optional binding
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder() //An object that decodes instances of data types from a property list
//            do {
//                itemArray = try decoder.decode([Item].self, from: data) //Must specify what the data type of the thing that is going to be deocded with ".self" included after it
//            } catch {
//                print ("Error decoding item array, \(error)")
//            }
//        }
//
//    }
