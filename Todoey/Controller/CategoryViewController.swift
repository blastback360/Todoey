//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nimat Azeez on 4/29/19.
//  Copyright © 2019 Nimat Azeez. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

//"CategoryViewController" inherits from the super class "SwipeTableViewController" to recieve all its functionalities
class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm() //Initializing a new "Realm"
    
    var categories: Results<Category>? //Setting the variable "categories" to type "Results" that will contain "Category" objects; "Results" is an auto-updating container type in Realm
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()

        tableView.separatorStyle = .none //Removal of the lines separating each cell
    }

    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 //If categories count is nil, just return 1; "??" is the "Nil Coalescing Operator"
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) //Tapping into the cell that gets created inside the super class at a certain indexPath
        
        if let category = categories?[indexPath.row] {
        
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.cellColor) else {fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
            //Older code; good for reference 
            //cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
            //cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].cellColor ?? "9A9A9A")
            //cell.backgroundColor = UIColor.randomFlat.hexValue()
        
        }
            
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController //Stores a reference to the destination view controller
        
        //Stores the indexPath of the selected tableView cell
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row] //Setting the "selectedCategory" property of our "destinationVC" equal to our array of "categories" at a certain index if it is not nil
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write { //Trying to write to our Realm database
                realm.add(category) //Trying to add a new category
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self) //Pulls out all of the "items" inside our Realm that are of "category" objects 
        
        tableView.reloadData()
    }
    
    
    //MARK: - Delete Data After Swipe
    
    //Ovveriding the functionalities of the "updateModel" method from the super class "SwipeTableViewController"
    override func updateModel(at indexPath: IndexPath) {

        //super.updateModel(at: indexPath) //It is possible to call functions that exist in your super class in this way
        
        //Deleting an item from our realm; use of optional binding because "categories" is an optional
        if let categoryForDeletion = self.categories?[indexPath.row] {

            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion) //Looks inside the collection of results called "categories" and deletes a category at a certain indexPath
                }
            } catch {
                print ("Error deleting category, \(error)")
            }
        }
    }
    
    //MARK: - Add New Categories 
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category() //Creation of an object from the "Category" class
            newCategory.name = textField.text!
            newCategory.cellColor = UIColor.randomFlat.hexValue() //Persisting the hexValue of a random color for a category cell using the ChameleonFramework 
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
}





