//
//  ViewController.swift
//  Todoey
//
//  Created by Kartheek Sabbisetty on 15/10/18.
//  Copyright © 2018 Kartheek Sabbisetty. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    @IBOutlet var listTableView: UITableView!
    
    var itemArray = [Item]();
    let appContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;

    var parentCategory : Category?{
        didSet{
            loadData()
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
                let item = Item(context: self.appContext);
                item.title = todoTitle;
                item.done = false;
                item.parentCategory = self.parentCategory;
                self.itemArray.append(item);
            
                self.saveDetails()
            
                //Updating the data in the userDefaults
//                self.userDefaults.setValue(self.itemArray, forKey: "TodoListItem");
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
    
    private func saveDetails(){
        do{
            try appContext.save();
        }catch{
            print("Error in saving the details")
        }
    }
    
    private func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest()){
        let predicate = NSPredicate(format: "parentCategory.title MATCHES %@", (self.parentCategory?.title)!)
        if request.predicate != nil {
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [request.predicate!,predicate])
            request.predicate = andPredicate;
        }else{
            request.predicate = predicate;
        }
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [request.predicate!,predicate])
        request.predicate = andPredicate;
        do{
            itemArray =  try appContext.fetch(request);
        }catch{
            print("Error in fetching the items : \(error)");
        }
        
        listTableView.reloadData()
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
//        appContext.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done;
        
        
        if itemArray[indexPath.row].done == false {
             tableCell?.accessoryType = .none;
        }else{
             tableCell?.accessoryType = .checkmark;
        }
        saveDetails();
//        if(tableCell?.accessoryType == UITableViewCellAccessoryType.checkmark){
//
//        }else{
//
//        }
    }
}

extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest();
        request.predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!);
      
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)];
        
        loadData(with: request)
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

