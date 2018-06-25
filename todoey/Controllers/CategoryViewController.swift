//
//  CategoryViewController.swift
//  todoey
//
//  Created by Supannee Mutitanon on 22/6/18.
//  Copyright © 2018 Supannee Mutitanon. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    //var categoryArray = [Category]()
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        //let item = categories[indexPath.row]
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category add yet"
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItem", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! todoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    @IBAction func addButoonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default){ (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            //self.categoryArray.append(newCategory)
            self.save(category: newCategory)
        }
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    func save(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() { //default parameter
        categories = realm.objects(Category.self)
//        tableView.reloadData()
    }
}
