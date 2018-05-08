//
//  ViewController.swift
//  Todoey
//
//  Created by HimanshuSmita on 5/2/18.
//  Copyright © 2018 Smita. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    let identifier:String = "TodoItemCell"
    var selCategory: Category? {
        didSet{
            loadItems()
        }
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
            
            let newItem = Item(context: self.context)
            newItem.title = myTextField.text!
            newItem.done = false
            newItem.parentCategory = self.selCategory
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
        
        
        do {
            try context.save()
        }catch{
            print("saving error \(error)")
        }
        
        tableView.reloadData()
        
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil )  {
       
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
            
        }else{
            request.predicate = categoryPredicate
        }

        do{
           itemArray = try context.fetch(request)
        }catch{
            print("error \(error)")
        }
        tableView.reloadData()

    }
 
    
}
  // MARK- searchbar methods

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        
           let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

            request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        
            loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                loadItems()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
                
            }
    }
}

