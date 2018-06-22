//
//  ViewController.swift
//  todoey
//
//  Created by Supannee Mutitanon on 19/6/18.
//  Copyright © 2018 Supannee Mutitanon. All rights reserved.
//

import UIKit
import CoreData

class todoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Category? {
        didSet{ //do when selectedCategory has value
            loadItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let newItem = Item(context: context)
//        newItem.title = "Find Mike"
//        newItem.done = false
//        itemArray.append(newItem)
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }
//        else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selectpath>>>\(itemArray[indexPath.row])")
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }
//        else {
//            itemArray[indexPath.row].done = false
//        }

//        itemArray.remove(at: indexPath.row)
//        context.delete(itemArray[indexPath.row])
//
        saveItem()
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New todoList Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItem()
        }
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
    }
    
    func saveItem(){
        do{
           try context.save()
        }
        catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) { //default parameter
        let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate,addtionalPredicate])
        }
        else {
            request.predicate = categorypredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate,predicate])
//
//        request.predicate = compoundPredicate
        do{
             itemArray = try context.fetch(request)
        }
        catch{
            print("Error load data from item \(error)")
        }
        tableView.reloadData()
    }

}

extension todoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
        request.predicate = predicate
        
        let sortDescriptr = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptr]
        
        loadItem(with: request,predicate: predicate)
//        do {
//            itemArray = try context.fetch(request)
//        }
//        catch{
//            print("Error fetching data from context \(error)")
//        }
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
}
