//
//  ToDoItems.swift
//  ToDoLists
//
//  Created by Heather Christman on 11/19/18.
//  Copyright © 2018 Heather Christman. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: NSDate = NSDate()
    
    var category = LinkingObjects(fromType: ToDoCategory.self, property: "items")
}
