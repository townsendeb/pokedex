//
//  Pokemon.swift
//  Pokedex
//
//  Created by Eric Townsend on 1/27/16.
//  Copyright © 2016 KrimsonTech. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _type: String!
    private var _description: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvoText: String!
    private var _nextEvoId: String!
    private var _nextEvoLevel: String!
    private var _pokemonUrl: String!
    
    var name: String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    var  description: String{
        if _description == nil {
            _description = ""
        }
        return _description
    }
    var  defense: String{
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    var height: String{
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var weight: String{
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    var nextEvoText: String {
        if _nextEvoText == nil {
            _nextEvoText = ""
        }
        return _nextEvoText
    }
    var nextEvoId: String {
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    var nextEvoLevel: String {
        if _nextEvoLevel == nil {
            _nextEvoLevel = ""
        }
        return _nextEvoLevel
    }
    
    
    // "/api/v1/pokemon/1/" use lazy loading to only load things when you need them
    
    
    init(name: String, pokedexId: Int) {
        self._pokedexId = pokedexId
        self._name = name
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    //creates url to download the information from the API
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: _pokemonUrl)!
        //makes the request!
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
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                print(self._height)
                print(self._weight)
                print(self._attack)
                print(self._defense)
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let name = types[0]["name"] { // grabs first name assigns it
                        self._type = name.capitalizedString
                    }
                    if types.count > 1 { //adds the slash inbetween the first and second types
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                            self._type! += "/\(name.capitalizedString)"
                        }
                      }
                    }
                } else {
                    self._type = ""
                }
                print(self._type)
                
                if let descArray = dict ["descriptions"] as? [Dictionary<String, String>] where
                    descArray.count > 0 {
                        if let url = descArray[0] ["resource_uri"] {
                            let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                            Alamofire.request(.GET, nsurl).responseJSON { response in
                                let result = response.result
                                
                                if let descDict = result.value as? Dictionary<String, AnyObject> {
                                    if let description = descDict["description"] as? String {
                                        self._description = description
                                        print(self._description)
                                    }
                                }
                                completed()
                           }
                } else {
                    self._description = ""
                }
                        
                        if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where
                            evolutions.count > 0 {
                                if let to = evolutions[0]["to"] as? String {
                                    if to.rangeOfString("mega") == nil { // cant supper mega pokemon in pokedex
                                        
                                        if let uri = evolutions[0]["resource_uri"] as? String {
                                            let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                            
                                            let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                            self._nextEvoId = num
                                            self._nextEvoText = to
                                            
                                            if let lvl = evolutions [0]["level"] as? Int {
                                            self._nextEvoLevel = "\(lvl)"
                                }
                                            
                                            print(self._nextEvoId)
                                            print(self._nextEvoLevel)
                                            print(self._nextEvoText)
                       }
                    }
                 }
              }
           }
        }
     }
  }
}
