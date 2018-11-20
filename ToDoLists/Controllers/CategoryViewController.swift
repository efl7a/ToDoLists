//
//  CategoryViewControllerTableViewController.swift
//  ToDoLists
//
//  Created by Heather Christman on 11/15/18.
//  Copyright © 2018 Heather Christman. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    lazy var realm = try! Realm()
    
    var categories: Results<ToDoCategory>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 80.0
    }

    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        let category = categories?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No Categories Available"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       self.performSegue(withIdentifier: "goToItemList", sender: indexPath)


    }
    //MARK: - Delete Data From Swipe
    
    override func deleteObjectFromDatabase(at indexPath: IndexPath) {
        if let category = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print("Error, \(error), deleting category")
            }

        }
    }
    
    
    // MARK: - Add new Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add New Category", style: .default) {
            (action) in
            
            let newCategory = ToDoCategory()
            newCategory.name = textField.text!
            
            self.saveCategories(category: newCategory)
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category here."
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Data Manipulation Methods - Saving and Fetching Data
    
    func saveCategories(category: ToDoCategory) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("There was an error saving: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(ToDoCategory.self)
        
        tableView.reloadData()
    }
    
    //MARK: TableView Delegate Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "goToItemList" {
            
            let destinationViewController = segue.destination as? ToDoListViewController
            
            let row = (sender as! NSIndexPath).row
//          if let indexPath = tableView.indexPathForSelectedRow { destinationViewController.category = ...}
            
            destinationViewController?.category = categories?[row]
            
        }
        
    }
}

