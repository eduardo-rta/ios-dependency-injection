//
//  RegistryIdentifier.swift
//  
//
//  Created by Eduardo Appolinario on 2022-06-24.
//

import Foundation

public struct RegistryIdentifier: Hashable {
    let id: ObjectIdentifier
    let name: String?
    
    init(id: ObjectIdentifier, name: String?) {
        self.id = id
        self.name = name
    }
}
