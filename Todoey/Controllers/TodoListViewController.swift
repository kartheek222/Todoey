//
//  ViewController.swift
//  Todoey
//
//  Created by Kartheek Sabbisetty on 15/10/18.
//  Copyright © 2018 Kartheek Sabbisetty. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    @IBOutlet var listTableView: UITableView!
    
    var itemArray : Results<Item>?
    let realm = try! Realm();
    
    var parentCategory : Category?{
        didSet{
        //    loadData()
        }
    };
//    let userDefaults = UserDefaults.standard;
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist");
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("plist file path : \(String(describing: dataFilePath))")

        loadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Todoey title", message: "", preferredStyle: .alert);
        
        var textField : UITextField?
        let addAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
               if let todoTitle = textField?.text {
                if let selectedCategory = self.parentCategory {
                    do{
                      try self.realm.write {
                            let item = Item();
                            item.title = todoTitle;
                            item.done = false;
                            selectedCategory.items.append(item);
                        }
                    }catch{
                        print("Error in saving the items.")
                    }
                }
                self.listTableView.reloadData();
            }
        }
        alertController.addAction(addAction);
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField { (titleTextField) in
            titleTextField.placeholder = "Create new item";
            textField = titleTextField;
        }
        present(alertController, animated: true, completion: nil);
        
    }
    
    private func loadData(){
        itemArray = parentCategory?.items.sorted(byKeyPath: "createDate", ascending: true)
        listTableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : TodoTableCell  =  tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TodoTableCell;

        if let item = itemArray?[indexPath.row]{
            tableCell.messageCell.text = item.title;
            tableCell.accessoryType = item.done ? .checkmark : .none;
        }else{
            tableCell.messageCell.text = "No items added";
        }
        
        return tableCell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        print("Clicked row \(indexPath.row), item : \(String(describing: itemArray?[indexPath.row]))")
        
        let tableCell =  tableView.cellForRow(at: indexPath);
        if let item = itemArray?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done;
                    tableCell?.accessoryType = item.done ? .checkmark : .none;
                }
            }catch{
                print("Error in updating the item status");
            }
        }
    }
}

extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text ?? "").sorted(byKeyPath: "createDate", ascending: true)
        listTableView.reloadData();
        print("Search button clicked : \(searchBar.text!)")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData();
            DispatchQueue.main.async {
                searchBar.resignFirstResponder();
            }
        }
    }
}

