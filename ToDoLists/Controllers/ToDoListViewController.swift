//
//  ViewController.swift
//  ToDoLists
//
//  Created by Heather Christman on 11/12/18.
//  Copyright © 2018 Heather Christman. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [ToDoItem]()

    var storeInDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = ToDoItem()
        item1.title = "something"
        itemArray.append(item1)
        
        let item2 = ToDoItem()
        item2.title = "something else"
        itemArray.append(item2)
        
        let item3 = ToDoItem()
        item3.title = "something different"
        itemArray.append(item3)
        
        if let items = storeInDefaults.array(forKey: "To Do List") as? [ToDoItem] {
            itemArray = items
        }
    }

    //MARK - TableView Datasource Methods
    
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
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do Item", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){
            (action) in
            
            let newItem = ToDoItem()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.storeInDefaults.set(self.itemArray, forKey: "To Do List")
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new item here."
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}

