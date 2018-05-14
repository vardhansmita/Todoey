//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by HimanshuSmita on 5/7/18.
//  Copyright © 2018 Smita. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController  {

    let realm = try! Realm()
    
    var categoryArr : Results<Category>?
    
    
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
       
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categoryArr?[indexPath.row]{
            //cell.textLabel?.text = categoryArr?[indexPath.row].name ?? "No Categories added yet"
           // cell.backgroundColor = UIColor(hexString: categoryArr?[indexPath.row].color ?? "32BDCA")
             cell.textLabel?.text = category.name
            
             guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
             cell.backgroundColor = categoryColor
             cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr?.count ?? 1
    }

   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: "goToItems", sender: self)
    
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let  indexPath = tableView.indexPathForSelectedRow{
       
        destinationVC.selCategory = categoryArr?[(indexPath.row)]
        }
        
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newtextField = UITextField()
        
        let alert =  UIAlertController(title: "Add Category Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            
            let newCat = Category()
            newCat.name = newtextField.text!
            newCat.color = UIColor.randomFlat.hexValue()
            //self.categoryArr.append(newCat)
            self.saveItems(category: newCat)
        }
        alert.addTextField { (alertTextField) in
            newtextField = alertTextField
            alertTextField.placeholder = "create new Category"
        }
        
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
        
    }
    //MARK:DATA MANIPULATION
    
    func saveItems(category: Category) {
        
        
        do {
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("saving error \(error)")
        }
        
        tableView.reloadData()
        
    }
    func loadCategories()  {
//        let  request: NSFetchRequest<Category> = Category.fetchRequest()
//        do{
//            categoryArr = try context.fetch(request)
//        }catch{
//            print("error \(error)")
//        }
        categoryArr = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    //MARK: DELETE DATA FROM SWIPE
    override func updateModel(at indexPath: IndexPath) {
      if let categoryForDeletion = self.categoryArr?[indexPath.row]{
            do{
                 try self.realm.write
                {
                  self.realm.delete(categoryForDeletion)
                 }
                 }catch{
                   print("error deleting \(error)")
                 }
            }
}

   
}

    

