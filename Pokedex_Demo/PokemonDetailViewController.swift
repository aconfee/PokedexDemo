//
//  PokemonDetailViewController.swift
//  Pokedex_Demo
//
//  Created by Adam estela on 3/11/17.
//  Copyright © 2017 Adam estela. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {

    var poke: Pokemon!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var weithtLabel: UILabel!
    @IBOutlet weak var baseAttackLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var evoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameLabel.text = self.poke.Name
        let img = UIImage(named: "\(self.poke.PokedexId)")
        self.pokeImage.image = img
        self.currentEvoImage.image = img
        self.idLabel.text = "\(self.poke.PokedexId)"
        
        poke.downloadPokemonDetails { 
            // Callback
            self.initializeUI()
        }
    }

    func initializeUI(){
        self.baseAttackLabel.text = self.poke.BaseAttack
        self.defenseLabel.text = self.poke.Defense
        self.heightLabel.text = self.poke.Height
        self.weithtLabel.text = self.poke.Weight
        self.typeLabel.text = self.poke.PokeType
        self.bioLabel.text = self.poke.Description
        
        if poke.NextEvoId == "" {
            self.evoLabel.text = "No evolutions"
            self.nextEvoImage.isHidden = true
        } else {
            self.nextEvoImage.isHidden = false
            self.nextEvoImage.image = UIImage(named: self.poke.NextEvoId)
            let evolutionText = "\(self.poke.NextEvoName) - LVL \(self.poke.NextEvoLevel)"
            self.evoLabel.text = evolutionText
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
