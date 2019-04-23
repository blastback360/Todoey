//
//  ViewController.swift
//  Todoey
//
//  Created by Nimat Azeez on 4/20/19.
//  Copyright © 2019 Nimat Azeez. All rights reserved.
//

import UIKit

//View controller that specializes in managing a table view; UITableViewController is the superclass 
class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard //Interface to the user's database, where you store key-value pairs persistently across launches of your app
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        //Setting the itemArray equal to the array in the UserDefaults
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
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
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //Assigns the "done" property at a certain index path the opposite value of the same "done" property at that same index path
        
        tableView.reloadData() //Reloads tableView
        
        tableView.deselectRow(at: indexPath, animated: true) //Allows for tableView cells to be momentarily highlighted instead of continously highlighted
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Creation of a UIAlert that will pop-up whenever the Add button is pressed
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //What will happen when the user clicks the Add button in our UIAlert; is represented as the button in the UIAlert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //Creation of Item object
            let newItem = Item()
            newItem.title = textField.text! //Assigning Item object the text from the text field
            
            self.itemArray.append(newItem) //Adds value of the textField to the end of the itemArray
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray") //Saves updated itemArray to the UserDefaults; the key identifies the array in the UserDefaults
            
            self.tableView.reloadData() //Reloads the tableView
        }
        
        //Adding a textField to the UIAlert; "alertTextField" inside the completion handler is gnamed by the programmer ... can be named something else
        alert.addTextField { (alertTextField) in

            alertTextField.placeholder = "Create new item" //Placeholder for the textField
            textField = alertTextField //Setting the textField variable the text from the alertTextField completion handler
        }
        
        alert.addAction(action) //Adding the action to the UIAlert
        
        present(alert, animated: true, completion: nil) //Code required to actually show alert
    }
    

}

