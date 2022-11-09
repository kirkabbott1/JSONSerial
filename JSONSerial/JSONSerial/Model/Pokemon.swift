//
//  Pokemon.swift
//  JSONSerial
//
//  Created by Kirk Abbott on 11/8/22.
//

import Foundation


struct Dragon {
    let damageRelations : DamageRelations
    let gameIndices : [GameIndices]
    let generation : NameUrl
    let id: Int
    let moveDamageClass : NameUrl
    let moves : [NameUrl]
    let name : String
    let pokemons : [Pokemon]
    
}
struct Pokemon {
    let pokemon : NameUrl
}

struct GameIndices {
    let gameIndex : Int
    let generation : NameUrl
}


struct DamageRelations {
    let doubleDamageFrom : [NameUrl]
    let doubleDamageTo : [NameUrl]
    let halfDamageFrom : [NameUrl]
    let halfDamageTo : [NameUrl]
    let noDamageFrom : [NameUrl]
    let noDamageTo : [NameUrl]
    
}

struct NameUrl {
    let name : String
    let url : String
}
