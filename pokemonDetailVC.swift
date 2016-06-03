//
//  pokemonDetailVC.swift
//  pokedex
//
//  Created by Daniel Ray on 5/31/16.
//  Copyright © 2016 Daniel Ray. All rights reserved.
//

import UIKit
import Alamofire

class pokemonDetailVC: UIViewController {
    
    @IBOutlet var evolutionLabel: UILabel!
    @IBOutlet weak var nextEvolutionImg: UIImageView!
    @IBOutlet weak var currentEvolutionImg: UIImageView!
    @IBOutlet weak var pokemonAttack: UILabel!
    @IBOutlet weak var pokedexId: UILabel!
    @IBOutlet weak var pokemonWeight: UILabel!
    @IBOutlet weak var pokemenheight: UILabel!
    @IBOutlet weak var pokemonDefense: UILabel!
    @IBOutlet weak var pokemonType: UILabel!
    @IBOutlet weak var pokemonDescription: UILabel!
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = pokemon.name.capitalizedString
        let img = UIImage(named: "\(pokemon.pokedexID)")
        pokeImage.image = img
        currentEvolutionImg.image = img
        pokemon.downloadPokemonDetails { 
            // This will be called after download is done
            self.updateUI()
            
        }

    }
    
    func updateUI() {
        
        pokemonDescription.text = pokemon.description
        pokemonType.text = pokemon.type
        pokemonDefense.text = "\(pokemon.defense)"
        pokemonAttack.text = "\(pokemon.attack)"
        pokemonWeight.text = pokemon.weight
        pokemenheight.text = pokemon.height
        pokedexId.text = "\(pokemon.pokedexID)"
        
        if pokemon.nextEvolutionID == "" {
            evolutionLabel.text = "No Evolutions"
            nextEvolutionImg.hidden = true
        } else {
            nextEvolutionImg.hidden = false
            nextEvolutionImg.image = UIImage(named: pokemon.nextEvolutionID)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            
            if pokemon.nextEvolutionLevel != "" {
                str += " - LVL \(pokemon.nextEvolutionLevel)"
            }
            evolutionLabel.text = str
            
        }
        
        
      
    
        
    
    }

    
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

   
}
