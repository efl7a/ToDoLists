//
//  ViewController.swift
//  ToDoLists
//
//  Created by Heather Christman on 11/12/18.
//  Copyright © 2018 Heather Christman. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [ToDoItem]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var category: ToDoCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
       
     }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ?  .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
                
        saveItems()
  
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do Item", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){
            (action) in
            
            let newItem = ToDoItem(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.category = self.category
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new item here."
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
   
    
    //MARK: - Encoding Data
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("There was an error saving: \(error)")
        }
        
        tableView.reloadData()
    }
    
//    func loadItems(with request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()) {
    func loadItems(with request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let chosenCategoryPredicate = NSPredicate(format: "%K == %@", "category", category!)
        
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [chosenCategoryPredicate, additionalPredicate])
            
            request.predicate = compoundPredicate
            
        } else {
            
            request.predicate = chosenCategoryPredicate
            
        }
    
       
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            itemArray = try context.fetch(request)

        } catch {
            print("retrieving error")
        }
        tableView.reloadData()
    }
    
    func didSelectCategoryCell(category: ToDoCategory) {
        print( "Recieved Category \(category.name!)")
    }
    
}

//MARK: - Search Bar Functionality

extension ToDoListViewController: UISearchBarDelegate {
    
    func  searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
   
        loadItems(predicate: predicate)
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


