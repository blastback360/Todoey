//
//  ViewController.swift
//  Todoey
//
//  Created by Nimat Azeez on 4/20/19.
//  Copyright © 2019 Nimat Azeez. All rights reserved.
//

import UIKit
import RealmSwift

//View controller that specializes in managing a table view; UITableViewController is the superclass 
class ToDoListViewController: UITableViewController {

    let realm = try! Realm() //Initializing a new "Realm"
    
    var todoItems: Results<Item>? //Setting the variable "todoItems" to type "Results" that will contain "Item" objects; "Results" is an auto-updating container type in Realm
    
    //Variable with a type of an optional "Category" entity; use of "didSet" which allows for code between blocks to be be run only after "selectedCategory" has been set to a value
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    //Creation of a file path to the documents folder; also creates a plist file named "Items.plist"
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

    
    //MARK - Tableview Datasource Methods

    //Required tableView func that sets the amount of rows required for a particular tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1 //If todoItems count is nil, just return 1; "??" is the "Nil Coalescing Operator"
    }

    //Required tableView func that sets which cell to be used for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) //Setting cell with identifier created in prototype cell from the TableViewController
        
        if let item = todoItems?[indexPath.row] { //The item that we are currently trying to set up for the cell
            
            cell.textLabel?.text = item.title
            
            //Ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    
    //tableView func that lets you know which row has been selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Updating data with Realm
        if let item = todoItems? [indexPath.row] { //Setting "item" to an "Item" object from the "todoItems" variable of type "Result"
            
            do {
                try realm.write { //Trying to write to our Realm database
                    item.done = !item.done //Setting the "done" property to the opposite of what it is now
                    //realm.delete(item) //Used to delete data from our Realm database
                }
            } catch {
                print ("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) //Allows for tableView cells to be momentarily highlighted instead of continously highlighted
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Creation of a UIAlert that will pop-up whenever the Add button is pressed
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //What will happen when the user clicks the Add button in our UIAlert; is represented as the button in the UIAlert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //Use of optional binding because our selected category is of data type optional category
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write { //Trying to write to our Realm database
                        
                        let newItem = Item() //Creating an Object of the "Item" class
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem) //Tapping into the "items" that belong to the current category and appending the new "items" to the "List"
                    }
                } catch {
                    print ("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
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
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true) //Setting "todoItems" to the "items" from the "selectedCategory" variable and sorting them in ascending order by their "title"

        tableView.reloadData()
    }

}

//MARK - SearchBar Delegate Methods

//Extends and splits up the functionality of the ToDoListViewController
//Good for making a current ViewController more modular and better organized
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        //Looks at the title of each item in the "todoItems" variable and checks to see if it CONTAINS a value; the argument (i.e. searchBar.text!) replaces the " %@ " to be passed into the function
        //Also sorts the results based on the date they were created
        //"[cd]" allows for it not to be case or diacritic sensitive
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }

    //searchBar method that detetcts when text in the search bar has changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

            //Assigns tasks to different threads; asking the DispatchQueue to get the main queue and run the code block on the main queue asynchronously
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() //Lets the searchBar know that it should no longer be the thing that is currently selected
            }
        }
    }
}

