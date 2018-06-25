//
//  Data.swift
//  todoey
//
//  Created by Supannee Mutitanon on 25/6/18.
//  Copyright © 2018 Supannee Mutitanon. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
   
}
