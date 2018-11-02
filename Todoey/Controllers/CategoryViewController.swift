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
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    @IBOutlet var categoryTableView: UITableView!
    
    private var itemsArray : Results<Category>?;
    
    private var realm  = try! Realm();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        categoryTableView.rowHeight = 80;
        categoryTableView.separatorStyle = .none;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.navigationBar.barTintColor = UIColor.white;
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        print("Deleting the item at index : \(indexPath.row)")
        if let deleteItem = self.itemsArray?[indexPath.row]{
          do{
              try self.realm.write {
                  self.realm.delete(deleteItem);
              }
//            categoryTableView.reloadData()
          }catch{
              print("Eror occured while deleting the item \(error)")
          }
      }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = super.tableView(tableView, cellForRowAt: indexPath) as! CategoryCell
        if let item = itemsArray?[indexPath.row]{
            
            categoryCell.title.text = item.title ;
//            if let bgColor = item.backgroudColor {
//                categoryCell.backgroundColor = item.baUIColor.init(hexString: bgColor)
//            }else{
//                categoryCell.backgroundColor = UIColor.white;
//            }
            categoryCell.backgroundColor = UIColor.init(hexString: item.backgroudColor ) ?? UIColor.white;
            categoryCell.title.textColor = ContrastColorOf(UIColor(hexString: item.backgroudColor)!, returnFlat: true)
            
            
        }else{
            categoryCell.title.text = "No categories added";
            
        }
        return categoryCell;
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
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
                category.backgroudColor = UIColor.randomFlat.hexValue();
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
