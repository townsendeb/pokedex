//
//  PokeCell.swift
//  Pokedex
//
//  Created by Eric Townsend on 1/27/16.
//  Copyright © 2016 KrimsonTech. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!
    
    
    //make the rounded edges for the cell, use required init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        nameLabel.text = self.pokemon.name.capitalizedString // capitalizes the first name in the string
        thumbImage.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
}
