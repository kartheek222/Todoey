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
    
    let itemArray = ["Item 1","Item 2", "Item 3"];
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureTableView();
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
        tableCell.messageCell.text = itemArray[indexPath.row];
        return tableCell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        print("Clicked row \(indexPath.row), item : \(itemArray[indexPath.row])")
        
        let tableCell =  tableView.cellForRow(at: indexPath);
        if(tableCell?.accessoryType == UITableViewCellAccessoryType.checkmark){
            tableCell?.accessoryType = .none;
        }else{
            tableCell?.accessoryType = .checkmark;
        }
    }
    
}
