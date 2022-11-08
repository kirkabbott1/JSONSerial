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
    
    func getPokemonManually() -> Pokemon? {
        guard let path = Bundle.main.path(forResource: "SampleJSONGlaceon", ofType: "json") else {
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
    
    private func parsePokemonManually(base: [String: Any]) -> Pokemon? {
        
        guard let abilitiesArr = base["abilities"] as? [[String: Any]] else {
            print("Failed ability Arr")
            return nil
        }
        
        // Abilities
        var returnAbilities: [Ability] = []
        abilitiesArr.forEach {
            guard let abilityDict = $0["ability"] as? [String: Any] else { return }
            guard let abilityRep = self.parseNameLink(nameLink: abilityDict) else { return }
            guard let isHidden = $0["is_hidden"] as? Bool else { return }
            guard let slot = $0["slot"] as? Int else { return }
            let ability = Ability(ability: abilityRep, isHidden: isHidden, slot: slot)
            returnAbilities.append(ability)
        }
        
        guard let baseExp = base["base_experience"] as? Int else { return nil }
        
        // Forms
        guard let formsArr = base["forms"] as? [[String: Any]] else { return nil }
        var returnForms: [NameLink] = []
        formsArr.forEach{
            guard let form = self.parseNameLink(nameLink: $0) else { return }
            returnForms.append(form)
        }
        
        // GameIndeces
        guard let gameIndecesArr = base["game_indices"] as? [[String: Any]] else { return nil }
        var returnGameIndeces: [GameIndex] = []
        gameIndecesArr.forEach{
            guard let gameIndex = $0["game_index"] as? Int else { return }
            guard let version = $0["version"] as? [String: Any] else { return }
            guard let returnVersion = self.parseNameLink(nameLink: version) else { return }
            let gameIndece = GameIndex(gameIndex: gameIndex, version: returnVersion)
            returnGameIndeces.append(gameIndece)
        }
        
        guard let height = base["height"] as? Int else { return  nil }
        guard let id = base["id"] as? Int else { return nil }
        guard let isDefault = base["is_default"] as? Bool else { return nil }
        guard let locationAreaEncounters = base["location_area_encounters"] as? String else { return nil }
        
        // Moves
        guard let movesArr = base["moves"] as? [[String: Any]] else { return nil }
        var returnMoves: [Move] = []
        movesArr.forEach {
            guard let moveDict = $0["move"] as? [String: Any] else { return }
            guard let moveRep = self.parseNameLink(nameLink: moveDict) else { return }
            let move = Move(move: moveRep)
            returnMoves.append(move)
        }
        
        guard let name = base["name"] as? String else { return nil }
        guard let order = base["order"] as? Int else { return nil }
        
        guard let speciesDict = base["species"] as? [String: Any] else { return nil }
        guard let species = self.parseNameLink(nameLink: speciesDict) else { return nil }
        
        
        // Sprites
        guard let spriteDict = base["sprites"] as? [String: Any] else { return nil }
        let backDefault = spriteDict["back_default"] as? String
        let backFemale = spriteDict["back_female"] as? String
        let backShiny = spriteDict["back_shiny"] as? String
        let backShinyFemale = spriteDict["back_shiny_female"] as? String
        let frontDefault = spriteDict["front_default"] as? String
        let frontFemale = spriteDict["front_female"] as? String
        let frontShiny = spriteDict["front_shiny"] as? String
        let frontShinyFemale = spriteDict["front_shiny_female"] as? String
        let sprites = Sprites(backDefault: backDefault, backFemale: backFemale, backShiny: backShiny, backShinyFemale: backShinyFemale, frontDefault: frontDefault, frontFemale: frontFemale, frontShiny: frontShiny, frontShinyFemale: frontShinyFemale)
        
        
        return Pokemon(abilities: returnAbilities,
                       baseExperience: baseExp,
                       forms: returnForms,
                       gameIndeces: returnGameIndeces,
                       height: height,
                       id: id,
                       isDefault: isDefault,
                       locationAreaEncounters: locationAreaEncounters,
                       moves: returnMoves,
                       name: name,
                       order: order,
                       species: species,
                       sprites: sprites)
    }
    
    private func parseNameLink(nameLink: [String: Any]) -> NameLink? {
        guard let name = nameLink["name"] as? String else { return nil }
        guard let url = nameLink["url"] as? String else { return nil }
        return NameLink(name: name, url: url)
    }
    
    
}
