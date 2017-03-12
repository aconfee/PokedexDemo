//
//  PokeCell.swift
//  Pokedex_Demo
//
//  Created by Adam estela on 3/9/17.
//  Copyright © 2017 Adam estela. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(_ pokemon: Pokemon){
        self.pokemon = pokemon
        
        self.nameLabel.text = self.pokemon.Name.capitalized
        self.thumbImage.image = UIImage(named: "\(self.pokemon.PokedexId)")
    }
    
}
