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

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    //MARK - Tableview Datasource Methods

    //Required tableView func that sets the amount of rows required for a particular tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count //Returns the number of rows
    }

    //Required tableView func that sets which cell to be used for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) //Setting cell with identifier created in prototype cell from the TableViewController
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    
    //tableView func that lets you know which row has been selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print (itemArray[indexPath.row])
        
        //If/else statement used to assign or unassign a checkmark to a cell in the tableView 
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true) //Allows for tableView cells to be momentarily highlighted instead of continously highlighted
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Creation of a UIAlert that will pop-up whenever the Add button is pressed
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //What will happen when the user clicks the Add button in our UIAlert; is represented as the button in the UIAlert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            self.itemArray.append(textField.text!) //Adds value of the textField to the end of the itemArray
            
            self.tableView.reloadData() //Reloads the tableView
        }
        
        //Adding a textField to the UIAlert; "alertTextField" inside the completion handler is given by user ... can be named something else
        alert.addTextField { (alertTextField) in

            alertTextField.placeholder = "Create new item" //Placeholder for the textField
            textField = alertTextField //Setting the textField variable the text from the alertTextField completion handler
        }
        
        alert.addAction(action) //Adding the action to the UIAlert
        
        present(alert, animated: true, completion: nil) //Code required to actually show alert
    }
    

}

