//
//  ViewController.swift
//  JSONSerial
//
//  Created by Kirk Abbott on 11/8/22.
//

import UIKit


class ViewController: UIViewController {

    lazy var manualDecodeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Decode it", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemTeal
        button.addTarget(self, action: #selector(self.manualDecodeButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
        
    }
    
    func createUI() {
        self.view.addSubview(self.manualDecodeButton)
        
        self.manualDecodeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.manualDecodeButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.manualDecodeButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        self.manualDecodeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc
    func manualDecodeButtonPressed() {
        print("Manual Button Pressed")
        let pokemon = NetworkManager.shared.getPokemonManually()
        self.presentPokemonAlert(pokemon: pokemon)
    }

    
    func presentPokemonAlert(pokemon: Pokemon?) {
        guard let pokemon = pokemon else { return }
        
        let moveNames = pokemon.moves.compactMap {
            return $0.move.name
        }
        
        let alert = UIAlertController(title: "Dragon", message: "\(moveNames)", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(okayAction)
        
        self.present(alert, animated: true)
        
    }
    

}



