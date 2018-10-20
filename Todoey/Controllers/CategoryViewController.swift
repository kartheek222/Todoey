//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kartheek Sabbisetty on 20/10/18.
//  Copyright © 2018 Kartheek Sabbisetty. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    @IBOutlet var categoryTableView: UITableView!
    
    private var itemsArray = [Category]();
    
    private var appContext  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        categoryCell.title.text = itemsArray[indexPath.row].title;
        
        return categoryCell;
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController;
        if let selectedIndex = self.categoryTableView.indexPathForSelectedRow {
            destinationVC.parentCategory = itemsArray[selectedIndex.row];
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
                let category = Category(context: self.appContext);
                category.title = categoryTextField?.text;
                self.itemsArray.append(category)
                
                //Saving the changes in teh DB
                do{
                    try self.appContext.save()
                }catch{
                    print("Error in saving the data\(error)")
                }
                
                self.categoryTableView.reloadData()
            }
        };
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        alertController.addAction(cancelAction);
        alertController.addAction(doneAction);
        present(alertController, animated: true, completion: nil);
    }
    
    private func loadData(){
        let request : NSFetchRequest<Category> = Category.fetchRequest();
        do{
            itemsArray = try appContext.fetch(request);
        }catch{
            print("Error in fetching the records \(error)");
        }
        
    }
    
    
}
