//
//  CategoryViewControllerTableViewController.swift
//  ToDoLists
//
//  Created by Heather Christman on 11/15/18.
//  Copyright © 2018 Heather Christman. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    lazy var realm = try! Realm()
    
    var categoryArray: Results<ToDoCategory>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }

    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        
        let category = categoryArray?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No Categories Available"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       self.performSegue(withIdentifier: "goToItemList", sender: indexPath)


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
        
        categoryArray = realm.objects(ToDoCategory.self)
        
        tableView.reloadData()
    }
    
    //MARK: TableView Delegate Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "goToItemList" {
            
            let destinationViewController = segue.destination as? ToDoListViewController
            
            let row = (sender as! NSIndexPath).row
//          if let indexPath = tableView.indexPathForSelectedRow { destinationViewController.category = ...}
            
            destinationViewController?.category = categoryArray?[row]
            
        }
        
    }
}
