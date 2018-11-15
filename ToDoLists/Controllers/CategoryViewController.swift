//
//  CategoryViewControllerTableViewController.swift
//  ToDoLists
//
//  Created by Heather Christman on 11/15/18.
//  Copyright © 2018 Heather Christman. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [ToDoCategory]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }

    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        cell.accessoryType = category.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       self.performSegue(withIdentifier: "goToItemList", sender: indexPath)


    }
    
    // MARK: - Add new Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "New Category", style: .default) {
            (action) in
            
            let newCategory = ToDoCategory(context: self.context)
            newCategory.name = textField.text!
            newCategory.done = false
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
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
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("There was an error saving: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<ToDoCategory> = ToDoCategory.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
            
            print(categoryArray)
            
        } catch {
            print("retrieving categories had an error")
        }
        tableView.reloadData()
    }
    
    //MARK: TableView Delegate Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "goToItemList" {
            
            let destinationViewController = segue.destination as? ToDoListViewController
            
            let row = (sender as! NSIndexPath).row
//          if let indexPath = tableView.indexPathForSelectedRow { destinationViewController.category = ...}
            
            destinationViewController?.category = categoryArray[row]
            
        }
        
    }
}
