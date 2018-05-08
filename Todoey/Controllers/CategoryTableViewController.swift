//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by HimanshuSmita on 5/7/18.
//  Copyright © 2018 Smita. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArr = [Category]()
    let identifierCell:String = "CategoryItemCell"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell, for: indexPath)
            cell.textLabel?.text = categoryArr[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }

   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: "goToItems", sender: self)
    
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
      let  indexPath = tableView.indexPathForSelectedRow
        destinationVC.selCategory = categoryArr[(indexPath?.row)!]
        
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newtextField = UITextField()
        
        let alert =  UIAlertController(title: "Add Category Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            
            let newCat = Category(context: self.context)
            newCat.name = newtextField.text!
            self.categoryArr.append(newCat)
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            newtextField = alertTextField
            alertTextField.placeholder = "create new Category"
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
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest())  {
        
        do{
            categoryArr = try context.fetch(request)
        }catch{
            print("error \(error)")
        }
        tableView.reloadData()
        
    }
}
