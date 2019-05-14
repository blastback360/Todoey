//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Nimat Azeez on 5/7/19.
//  Copyright © 2019 Nimat Azeez. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    var cell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.rowHeight = 80.0 //Increasing the size of our cell
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell //Downcasting the cell to be a SwipeTableViewCell
        
        cell.delegate = self //Keeping the delegate in this class because this is the class that deals with all the deletions 
        
        return cell
    }

    //MARK: - Swipe Cell Delegate Methods
        
    //Adopting the SwipeTableViewCellDelegate protocol; this method is responsible for what should happen when a user swipes on a cell
    //Must specify in the Main.storyboard that the cell should inherit from the "SwipeTableViewCell" and the module where the class is loacted which is "SwipeCellKit"
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            
        guard orientation == .right else { return nil } //Checks if the orientation of the swipe is from the right
            
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath) //Calls function "updateModel" that will be overriden by the "updateMethod" in the "CategoryViewController"
            
        }
            
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
            
        return [deleteAction]
    }
        
    //Customizing the behaivor of the swipe actions
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive //Allows for a full swipe to call the delete action
        //options.transitionStyle = .border //Allows all the buttons to show up and increase in size at the same time; not neccasary for this project
        return options
        }
    
    
    func updateModel(at indexPath: IndexPath) {
        //Update our data model
        
    }

}
