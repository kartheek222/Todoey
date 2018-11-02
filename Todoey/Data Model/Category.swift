//
//  Category.swift
//  Todoey
//
//  Created by Kartheek Sabbisetty on 21/10/18.
//  Copyright © 2018 Kartheek Sabbisetty. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title : String = "";
    @objc dynamic var backgroudColor = "";
    var items  = List<Item>();
}
