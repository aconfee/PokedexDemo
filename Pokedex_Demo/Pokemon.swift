//
//  Pokemon.swift
//  Pokedex_Demo
//
//  Created by Adam estela on 3/6/17.
//  Copyright © 2017 Adam estela. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var name: String!
    private var pokedexId: Int!
    private var description: String!
    private var type: String!
    private var defense: String!
    private var height: String!
    private var weight: String!
    private var baseAttack: String!
    private var nextEvoText: String!
    private var pokemonUrl: String!
    
    private var nextEvolutionName: String!
    private var nextEvolutionId: String!
    private var nextEvolutionLevel: String!
    
    var Name: String {
        return self.name
    }
    
    var PokedexId: Int {
        return self.pokedexId
    }
    
    var Description: String {
        if self.description == nil {
            self.description = ""
        }
        return self.description
    }
    
    var PokeType: String {
        if self.type == nil {
            self.type = ""
        }
        return self.type
    }
    
    var Defense: String {
        if self.defense == nil {
            self.defense = ""
        }
        return self.defense
    }
    
    var Height: String {
        if self.height == nil {
            self.height = ""
        }
        return self.height
    }
    
    var Weight: String {
        if self.weight == nil {
            self.weight = ""
        }
        return self.weight
    }
    
    var BaseAttack: String {
        if self.baseAttack == nil {
            self.baseAttack = ""
        }
        return self.baseAttack
    }
    
    var NextEvoText: String {
        if self.nextEvoText == nil {
            self.nextEvoText = ""
        }
        return self.nextEvoText
    }
    
    var NextEvoName: String {
        if self.nextEvolutionName == nil {
            self.nextEvolutionName = ""
        }
        return self.nextEvolutionName
    }
    
    var NextEvoId: String {
        if self.nextEvolutionId == nil {
            self.nextEvolutionId = ""
        }
        return self.nextEvolutionId
    }
    
    var NextEvoLevel: String {
        if self.nextEvolutionLevel == nil {
            self.nextEvolutionLevel = ""
        }
        return self.nextEvolutionLevel
    }
    
    init(name: String, pokedexId: Int){
        self.name = name.capitalized
        self.pokedexId = pokedexId
        self.pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId!)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete){
        Alamofire.request(self.pokemonUrl).responseJSON{(response) in
            if let dict = response.result.value as? Dictionary<String, Any>{
                if let weight = dict["weight"] as? String {
                    self.weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self.height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self.baseAttack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int{
                    self.defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {
                    if let name = types[0]["name"] {
                        self.type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self.type! += " / \(name.capitalized)"
                            }
                        }
                    }
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, Any>] , evolutions.count > 0 {
                    if let nextEvolution = evolutions[0]["to"] as? String {
                        if nextEvolution.range(of: "mega") == nil {
                            self.nextEvolutionName = nextEvolution
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                self.nextEvolutionId = nextEvoId
                                
                                if let lvlExist = evolutions[0]["level"] {
                                    if let lvl = lvlExist as? Int {
                                        self.nextEvolutionLevel = "\(lvl)"
                                    }
                                }
                            }
                        }
                    }
                }
                
                if let descriptionArray = dict["descriptions"] as? [Dictionary<String, String>] , descriptionArray.count > 0 {
                    if let url = descriptionArray[0]["resource_uri"] {
                        
                        let descriptionUrl = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(descriptionUrl).responseJSON(completionHandler: { (response) in
                            if let descriptionDict = response.result.value as? Dictionary<String, Any> {
                                if let description = descriptionDict["description"] as? String {
                                    self.description = description
                                }
                            }
                            
                            completed()
                        })
                    }
                }
            }
        }
    }
}
