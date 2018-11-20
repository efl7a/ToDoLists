//
//  ViewController.swift
//  ToDoLists
//
//  Created by Heather Christman on 11/12/18.
//  Copyright © 2018 Heather Christman. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {
    
    lazy var realm = try! Realm()

    var toDoItems: Results<ToDoItem>?

    var category: ToDoCategory? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0

     }

    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ?  .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items"
        }
      
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !(item.done)
                }
            } catch {
                
                print("Error saving done change \(error)")
            }
            
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    //MARK: - Delete Item with Swipe
    
    override func deleteObjectFromDatabase(at indexPath: IndexPath) {
        if let item = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error deleting item: \(error)")
            }
        }
    }

    //MARK: - Add New Item

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New To Do Item", message: " ", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default){
            (action) in
            
            if let currentCategory = self.category {
                do {
                    try self.realm.write {
                        let newItem = ToDoItem()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new Item: \(error)")
                }
            }
            
            
            self.tableView.reloadData()


        }

        alert.addAction(action)

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new item here."
            textField = alertTextField
        }

        present(alert, animated: true, completion: nil)
    }


    //MARK: - Encoding Data

    func loadItems() {

        toDoItems = category?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }

    func didSelectCategoryCell(category: ToDoCategory) {
//        print( "Recieved Category \(category.name!)")
    }

}

//MARK: - Search Bar Functionality

extension ToDoListViewController: UISearchBarDelegate {

    func  searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        toDoItems = toDoItems?.filter(predicate).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()

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


