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
    
    //Creation of a file path to the documents folder; also creates a plist file named "Items.plist"
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //let defaults = UserDefaults.standard //Interface to the user's database, where you store key-value pairs persistently across launches of your app
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
        loadItems()
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
            
            //Creation of Item object
            let newItem = Item()
            newItem.title = textField.text! //Assigning Item object the text from the text field
            
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
    
    //MARK - Model Manupulation Methods
    
    func saveItems() {
        
        let encoder = PropertyListEncoder() //An object that encodes instances of data types to a property list
        
        //Encoding and writing methods can throw an errors, so they must be put into a do-catch block
        do {
            let data = try encoder.encode(itemArray) //Encodes the itemArray into a property list 
            try data.write(to: dataFilePath!) //Writes data to our dataFilePath
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        tableView.reloadData() //Reloads the tableView
    }
    
    func loadItems() {
        
        //Taps into our data from our dataFilePath; may also throw an error so is marked with a "try?" and assigned to the data variable using optional binding
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder() //An object that decodes instances of data types from a property list
            do {
                itemArray = try decoder.decode([Item].self, from: data) //Must specify what the data type of the thing that is going to be deocded with ".self" included after it 
            } catch {
                print ("Error decoding item array, \(error)")
            }
        }

    }
}

