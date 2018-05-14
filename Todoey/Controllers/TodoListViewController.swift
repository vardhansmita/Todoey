//
//  ViewController.swift
//  Todoey
//
//  Created by HimanshuSmita on 5/2/18.
//  Copyright © 2018 Smita. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    var selCategory: Category? {
        didSet{
           loadItems()
        }
    }

    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var todoItems : Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
      //  print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = selCategory!.name
        
        guard let colourHex = selCategory?.color else {fatalError()}
            guard let navBar = navigationController?.navigationBar else {fatalError("navigation contrller doesnot exit")}
        guard let navBarColur = UIColor(hexString: colourHex) else {fatalError()}
                navBar.barTintColor = navBarColur
                navBar.tintColor = ContrastColorOf(navBarColur, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColur, returnFlat: true)]
            
           
        
        
        
    }
    
    
    //MARK: Tableview datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if  let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            //if let colour = FlatSkyBlue().darken(byPercentage: CGFloat(indexPath.row ) /  CGFloat(todoItems!.count)){
            if let colour = UIColor(hexString: selCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row ) /  CGFloat(todoItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                }
            
                cell.accessoryType =  item.done == true ? .checkmark : .none
        }else{
                cell.textLabel?.text = "No Cell"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    //MARK: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = todoItems?[indexPath.row]{
            do{
            try realm.write {
                //realm.delete(item)
                item.done = !item.done
                }
                
            }
            catch{
                print("error saving done status  \(error)")
            }
        }
        tableView.reloadData()
       // todoItems?[indexPath.row].done = !(todoItems[indexPath.row].done)
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var myTextField = UITextField()
        
        let alert =  UIAlertController(title: "Add todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            
            if let currentCategory = self.selCategory{
                do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = myTextField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    }
                    
                }
                catch{
                      print("error saving new items \(error)")
                    }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            myTextField = alertTextField
            alertTextField.placeholder = "create new item"
        }
        
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
        
    }

    func loadItems()  {
        todoItems = selCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

    }
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = todoItems?[indexPath.row]{
            do{
                try realm.write
                {
                    realm.delete(itemForDeletion)
                }
            }catch{
                print("error deleting \(error)")
            }
        }
 
    
}
}
  // MARK- searchbar methods

extension TodoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     //   todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        self.todoItems = self.todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        self.tableView.reloadData()

//        let request:NSFetchRequest<Item> = Item.fetchRequest()
//
//           let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//            request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]

  //          loadItems(with: request, predicate: predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                self.loadItems()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }

            }
    }
}

