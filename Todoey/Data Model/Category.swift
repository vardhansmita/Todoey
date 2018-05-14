//
//  Category.swift
//  Todoey
//
//  Created by HimanshuSmita on 5/8/18.
//  Copyright © 2018 Smita. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
    
}
