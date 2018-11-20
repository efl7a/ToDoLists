//
//  Category.swift
//  ToDoLists
//
//  Created by Heather Christman on 11/19/18.
//  Copyright © 2018 Heather Christman. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoCategory: Object {
    @objc dynamic var name: String = ""
    let items = List<ToDoItem>()
}
