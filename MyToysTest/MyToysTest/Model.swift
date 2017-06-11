//
//  Model.swift
//  MyToysTest
//
//  Created by LiLietz on 11.06.17.
//  Copyright © 2017 LiLietz. All rights reserved.
//

import Foundation

enum ModelType: String {
    case section = "section"
    case node = "node"
    case link = "link"
    case undefined = ""
}

struct Model {
    let type: ModelType
    let label: String
    let url: String?
    var children: [Model]?
    
    init(json: [String: Any]) {
        
        let currentType = json["type"] as? String ?? ""
        
        self.type = ModelType(rawValue: currentType) ?? .undefined
        self.label = json["label"] as? String ?? ""
        self.url = json["url"] as? String ?? ""
        
        if let childrenJson = json["children"] as? [[String: Any]] {
            var currentChildren: [Model] = []
            for childJson in childrenJson {
                currentChildren.append(Model(json: childJson))
            }
            self.children = currentChildren
        }
    }
}
