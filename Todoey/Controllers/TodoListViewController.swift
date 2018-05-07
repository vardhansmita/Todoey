//
//  ViewController.swift
//  Todoey
//
//  Created by HimanshuSmita on 5/2/18.
//  Copyright © 2018 Smita. All rights reserved.
//

import UIKit

struct MorphyProperty {
    var type:MorphyTypeValue
    var key:String
    var value:AnyObject
    enum MorphyTypeValue {
        case Int,String,Double
    }
}

class TodoListViewController: UITableViewController {

    let identifier:String = "TodoItemCell"
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         loadItems()

    }
    
    
    //MARK: Tableview datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
       cell.accessoryType =  item.done == true ? .checkmark : .none

        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //MARK: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var myTextField = UITextField()
        
        let alert =  UIAlertController(title: "Add todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = myTextField.text!
            
            self.itemArray.append(newItem)
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            myTextField = alertTextField
            alertTextField.placeholder = "create new item"
        }
        
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
        
    }
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data =  try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding item array \(error)")
        }
        self.tableView.reloadData()
        
    }
    func loadItems() {
         if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
            try itemArray = decoder.decode([Item].self, from: data)
            }catch{
                print("error decoding \(error)")
                
            }
        }
        
    }
}

