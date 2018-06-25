//
//  Category.swift
//  todoey
//
//  Created by Supannee Mutitanon on 25/6/18.
//  Copyright © 2018 Supannee Mutitanon. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
