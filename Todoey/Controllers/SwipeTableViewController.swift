//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by HimanshuSmita on 5/11/18.
//  Copyright © 2018 Smita. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {
    let identifierCell:String = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
         tableView.separatorStyle = .none

    }
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                self.updateModel(at: indexPath)
                print("delete items")

            }
            
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete")
            
            return [deleteAction]
        }
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
            var options = SwipeTableOptions()
            options.expansionStyle = .destructive
            // options.transitionStyle = .border
            return options
        }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell, for: indexPath) as! SwipeTableViewCell
         cell.delegate = self
        return cell
    }
    func updateModel(at indexPath:IndexPath) {
        
    }
  
}
