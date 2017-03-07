//
//  Pokemon.swift
//  Pokedex_Demo
//
//  Created by Adam estela on 3/6/17.
//  Copyright © 2017 Adam estela. All rights reserved.
//

import Foundation

class Pokemon {
    
    private var name: String!
    private var pokedexId: Int!
    
    public var Name: String {
        return self.name
    }
    
    public var PokedexId: Int {
        return self.pokedexId
    }
    
    init(name: String, pokedexId: Int){
        self.name = name
        self.pokedexId = pokedexId
    }
}
