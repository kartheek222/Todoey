//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kartheek Sabbisetty on 20/10/18.
//  Copyright © 2018 Kartheek Sabbisetty. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    @IBOutlet var categoryTableView: UITableView!
    
    private var itemsArray : Results<Category>?;
    
    private var realm  = try! Realm();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        categoryCell.title.text = itemsArray?[indexPath.row].title ?? "No categories added";
        
        return categoryCell;
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController;
        if let selectedIndex = self.categoryTableView.indexPathForSelectedRow {
            destinationVC.parentCategory = itemsArray?[selectedIndex.row];
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var categoryTextField : UITextField?;
        let alertController = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert);
        alertController.addTextField { (textField) in
            textField.placeholder = "Add a new category";
            categoryTextField = textField;
        }
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            if (categoryTextField?.text?.count)! > 0{
                let category = Category();
                category.title = (categoryTextField?.text)!;
//                self.itemsArray.append(category)
                
                self.save(category: category);
                
                self.categoryTableView.reloadData()
            }
        };
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        alertController.addAction(cancelAction);
        alertController.addAction(doneAction);
        present(alertController, animated: true, completion: nil);
    }
    
    private func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error while saving the category object")
        }
    }
    
    private func loadData(){
        itemsArray = realm.objects(Category.self);
        
        
    }
    
    
}
