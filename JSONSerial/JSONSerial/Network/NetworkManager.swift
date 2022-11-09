//
//  NetworkManager.swift
//  JSONSerial
//
//  Created by Kirk Abbott on 11/8/22.
//

import Foundation



// 3 Requirements to make a perfect singleton
// 1. Final class
// 2. static shared property
// 3. private initializer

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {
        
    }
    
}
// MARK: Manual Decoding
extension NetworkManager {
    
    func getPokemonManually() -> Dragon? {
        guard let path = Bundle.main.path(forResource: "SampleJSONDragon", ofType: "json") else {
            return nil
        }
        
        let url = URL(filePath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let jsonObj = try JSONSerialization.jsonObject(with: data)
            guard let baseDict = jsonObj as? [String: Any] else { return nil }
            return self.parsePokemonManually(base: baseDict)
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parsePokemonManually(base: [String: Any]) -> Dragon? {
//
//
        guard let damageRelations = base["damage_relations"] as? [String: Any]
        else {
            return nil}
        
        guard let doubleDamageFromArr = damageRelations["double_damage_from"] as? [[String: Any]] else {
            return nil}
        
        var doubleDamageFrom : [NameUrl] = []
        
        doubleDamageFromArr.forEach(){
            guard let temp = self.parseNameLink(nameLink: $0) else {
                return}
            doubleDamageFrom.append(temp)
        }
        //double damage to
        guard let doubleDamageToArr = damageRelations["double_damage_to"] as? [[String:Any]] else {
            return nil}
        var doubleDamageTo : [NameUrl] = []
        doubleDamageToArr.forEach(){
            guard let temp = self.parseNameLink(nameLink: $0) else {
                return}
            doubleDamageTo.append(temp)
        }
        
        
        //halfDamageFrom
        guard let halfDamageFromArr = damageRelations["half_damage_from"] as? [[String:Any]] else {
            return nil}
        var halfDamageFrom : [NameUrl] = []
        halfDamageFromArr.forEach(){
            guard let temp = self.parseNameLink(nameLink: $0) else{
                return}
            halfDamageFrom.append(temp)
        }
        //halfDamageTo
        guard let halfDamageToArr = damageRelations["half_damage_to"] as? [[String:Any]] else {
            return nil}
        var halfDamageTo : [NameUrl] = []
        halfDamageToArr.forEach(){
            guard let temp = self.parseNameLink(nameLink: $0) else{
                return}
            halfDamageTo.append(temp)
        }
        //noDamageFrom
        guard let noDamageFromArr = damageRelations["no_damage_from"] as? [[String:Any]] else {
            return nil}
        var noDamageFrom : [NameUrl] = []
        noDamageFromArr.forEach(){
            guard let temp = self.parseNameLink(nameLink: $0) else{
                return}
            noDamageFrom.append(temp)
        }
        //noDamageTo
        guard let noDamageToArr = damageRelations["no_damage_to"] as? [[String:Any]] else{
            return nil}
        var noDamageTo : [NameUrl] = []
        noDamageToArr.forEach(){
            guard let temp = self.parseNameLink(nameLink: $0) else{
                return}
            noDamageTo.append(temp)
        }
        

        let damage = DamageRelations(doubleDamageFrom: doubleDamageFrom, doubleDamageTo: doubleDamageTo, halfDamageFrom: halfDamageFrom, halfDamageTo: halfDamageTo, noDamageFrom: noDamageFrom, noDamageTo: noDamageTo)
        //gameIndices
        guard let gameIndicesArr = base["game_indices"] as? [[String: Any]] else{
            return nil}
        var gameIndices : [GameIndices] = []
        gameIndicesArr.forEach(){
            guard let gameIndex = $0["game_index"] as? Int else{
                return}
            guard let generation = $0["generation"] as? [String:Any] else{
                return}
            guard let returnGeneration = self.parseNameLink(nameLink: generation) else {
                return}
            gameIndices.append(GameIndices(gameIndex:gameIndex, generation: returnGeneration))
        }
        
        
        // generation
        guard let generation = base["generation"] as? [String: Any]else {
            return nil}
        guard let regeneration = self.parseNameLink(nameLink: generation) else{
            return nil}
//        let
        
        // id
        guard let id = base["id"] as? Int else{
            return nil}
        
        //moveDamageClass
        guard let moveDamageClass = base["move_damage_class"] as? [String : Any] else {
            return nil}
        guard let removeDamageClass = self.parseNameLink(nameLink:moveDamageClass) else {
            return nil }
        
        //moves
        guard let movesArr = base["moves"] as? [[String: Any]]else {
            return nil}
        var moves : [NameUrl] = []
        movesArr.forEach(){
            guard let move = self.parseNameLink(nameLink: $0) else {return}
            moves.append(move)
        }
        
        // name
        
        guard let name = base["name"] as? String else{return nil}
        
        // pokemons
        guard let pokemonArr = base["pokemon"] as? [[String:Any]] else{return nil}
        var pokemons :[Pokemon] = []
        pokemonArr.forEach(){
            guard let pokemon = $0["pokemon"] as? [String : Any] else {return}
            guard let poke = self.parseNameLink(nameLink: pokemon) else{return}
            pokemons.append(Pokemon(pokemon: poke))
        }
        
        
        return Dragon(damageRelations: damage, gameIndices: gameIndices, generation: regeneration, id: id, moveDamageClass: removeDamageClass, moves: moves, name: name, pokemons: pokemons)
    }
    
    private func parseNameLink(nameLink: [String: Any]) -> NameUrl? {
        guard let name = nameLink["name"] as? String else { return nil }
        guard let url = nameLink["url"] as? String else { return nil }
        return NameUrl(name: name, url: url)
    }
    
    
}
