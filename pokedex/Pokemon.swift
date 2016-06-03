//
//  Pokemon.swift
//  pokedex
//
//  Created by Daniel Ray on 5/31/16.
//  Copyright © 2016 Daniel Ray. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexID: Int!
    private var _description: String!
    private var _attack: Int!
    private var _defense: Int!
    private var _height: String!
    private var _weight: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionID: String!
    private var _pokemonURL: String!
    private var _type: String!
    private var _nextEvolutionLevel: String!

    
    var name: String {
        
        get {
            if _name == nil {
                return ""
            }
            return _name
        }
    }
    
    var pokedexID: Int {
        get {
            if _pokedexID == nil {
                return 1
            }
            
            return _pokedexID
        }
        
    }
    var description: String {
        
        get {
            if _description == nil {
                return ""
            }
            return _description
        }
        
    }
    
    var attack: Int {
        get {
            if _attack == nil {
                return 0
            }
            return _attack
        }
        
    }
    
    var defense: Int {
        
        get {
            if _defense == nil {
                return 0
            }
            
            return _defense
  
        }
    }
    
    var height: String {
        get {
            if _height == nil {
                return ""
            }
            return _height
        }
        
    }
    
    var weight: String {
        get {
            
            if _weight == nil {
                return ""
            }
            return _weight
        }
    }
    
    var nextEvolutionTxt: String {
        get {
            
            if _nextEvolutionLevel == nil {
                return ""
            }
            return _nextEvolutionTxt
        }
        
    }
    
    var nextEvolutionID: String {
        get {
            
            if _nextEvolutionID  == nil {
                return ""
            }
            return _nextEvolutionID
        }
        
    }
    
    var nextEvolutionLevel: String {
        get {
            if _nextEvolutionLevel == nil {
                return ""
            }
            return _nextEvolutionLevel
        }
        
    }
    
    var type: String {
        get {
            if _type == nil {
                return ""
            }
            return _type
        }
        
    }
    
    init(name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
        self._pokemonURL = "\(BASE_URL)\(URL_POKEMON)\(self.pokedexID)"
        
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: self._pokemonURL)!
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = attack
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = defense
                }
                
                
                // print(self._attack)
                // print(self._defense)
                // print(self._height)
                // print(self._weight)
                
                if let types = dict["types"] as? [Dictionary<String,String>]  where types.count > 0 {
                    if let type = types[0]["name"] {
                        self._type = type
                    }
                    if types.count > 1 {
                        for x in 1 ..< types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                // print(self._type)
                
                if let descArr = dict["descriptions"] as? [Dictionary<String,String>] where descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(BASE_URL)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            let desResult = response.result
                            if let desDict = desResult.value as? Dictionary<String, AnyObject> {
                                if let description = desDict["description"] as? String {
                                    self._description = description
                                    // print(self._description)
                                }
                            }
                            
                            completed()
                        }
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String {
                        
                        // Cannot support mega pokemon right now
                        //api still has mega data
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvolutionID = num
                                self._nextEvolutionTxt = to.capitalizedString
                                
                                if let level = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLevel = "\(level)"
                                }
                                
                                // print(self._nextEvolutionLevel)
                                //print(self._nextEvolutionID)
                                // print(self._nextEvolutionTxt)
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    
}
