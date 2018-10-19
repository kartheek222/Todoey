//
//  ViewController.swift
//  Todoey
//
//  Created by Kartheek Sabbisetty on 15/10/18.
//  Copyright © 2018 Kartheek Sabbisetty. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    @IBOutlet var listTableView: UITableView!
    
    var itemArray = [Item]();
    
    let userDefaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let itemsList = userDefaults.array(forKey: "TodoListItem") as? [Item]{
            itemArray = itemsList;
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Todoey title", message: "", preferredStyle: .alert);
        
        var textField : UITextField?
        let addAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
           if let todoTitle = textField?.text {
                let item = Item();
                item.title = todoTitle;
                self.itemArray.append(item);
                //Updating the data in the userDefaults
                self.userDefaults.setValue(self.itemArray, forKey: "TodoListItem");
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
    
    private func configureTableView(){
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : TodoTableCell  =  tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TodoTableCell;
        tableCell.messageCell.text = itemArray[indexPath.row].title;
        if itemArray[indexPath.row].done == false {
            tableCell.accessoryType = .none;
        }else{
            tableCell.accessoryType = .checkmark;
        }
        
        return tableCell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        print("Clicked row \(indexPath.row), item : \(itemArray[indexPath.row])")
        
        let tableCell =  tableView.cellForRow(at: indexPath);
        
        if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true;
             tableCell?.accessoryType = .checkmark;
        }else{
            itemArray[indexPath.row].done = false;
             tableCell?.accessoryType = .none;
        }
//        if(tableCell?.accessoryType == UITableViewCellAccessoryType.checkmark){
//
//        }else{
//
//        }
    }
    
}

