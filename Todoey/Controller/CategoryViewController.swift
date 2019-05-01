//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nimat Azeez on 4/29/19.
//  Copyright © 2019 Nimat Azeez. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //Used to create, read, update, and delete our data; what communicates with our persistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name

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
            destinationVC.selectedCategory = categories[indexPath.row] //Setting the "selectedCategory" property equal to our array of "categories" at a certain index
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest() //Gets back all the NSManagedObjects that were created using the Category entity
        
        do {
        categories = try context.fetch(request) //Saves whatever gets returned into our "categories" array
        } catch {
            print ("Error loading categories \(error)")
        }
        
        tableView.reloadData()
    }
    //MARK: - Add New Categories 
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
}
