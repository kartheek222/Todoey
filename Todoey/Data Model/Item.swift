//
//  Item.swift
//  Todoey
//
//  Created by Kartheek Sabbisetty on 21/10/18.
//  Copyright © 2018 Kartheek Sabbisetty. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = "";
    @objc dynamic var done : Bool = false;
    @objc dynamic var createDate  = Date();
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
