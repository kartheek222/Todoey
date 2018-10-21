//
//  Data.swift
//  Todoey
//
//  Created by Kartheek Sabbisetty on 21/10/18.
//  Copyright © 2018 Kartheek Sabbisetty. All rights reserved.
//

import Foundation
import RealmSwift
class Data: Object {
    @objc dynamic var name : String = "";
    @objc dynamic var age : Int = 1;
}
