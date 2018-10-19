//
//  Item.swift
//  Todoey
//
//  Created by Kartheek Sabbisetty on 18/10/18.
//  Copyright © 2018 Kartheek Sabbisetty. All rights reserved.
//

import Foundation

class Item : Encodable, Decodable{
    var title : String = "";
    var done : Bool = false;
}
