//
//  PokemonDetailViewController.swift
//  PokemonApp
//
//  Created by liga.griezne on 07/11/2023.
//

import UIKit

class PokemonDetailViewController: UIViewController {

    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var supertypeLabel: UILabel!
    @IBOutlet weak var subtypeLabel: UILabel!
    @IBOutlet weak var evolvesLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var cardSetLabel: UILabel!
    @IBOutlet weak var pokemonTextLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artisLabel: UILabel!
    
    var pokemon: Card?

    override func viewDidLoad() {
        super.viewDidLoad()
                
        if let selectedPokemon = pokemon {
            nameLabel.text = selectedPokemon.name
            if let pokedexNr = selectedPokemon.nationalPokedexNumber {
                pokedexLabel.text = pokedexNr.codingKey.stringValue
            } else {
                pokedexLabel.text = "N/A"
            }
            
            let picURL = selectedPokemon.imageURL
            
            setImageFromStringrURL(stringUrl: picURL)
            
            if let pokedemonCost = selectedPokemon.convertedRetreatCost {
                costLabel.text = pokedemonCost.codingKey.stringValue
            } else {
                costLabel.text = "N/A"
            }
            
            if let allTypes = selectedPokemon.types {
                typeLabel.text = allTypes.joined(separator: " ")
            } else {
                typeLabel.text = "N/A"
            }
            if let pokemonSupertype = selectedPokemon.supertype {
                supertypeLabel.text = pokemonSupertype
            } else {
                supertypeLabel.text = "N/A"
            }
            if let pokemonSubtype = selectedPokemon.subtype {
                subtypeLabel.text = pokemonSubtype
            } else {
                subtypeLabel.text = "N/A"
            }
            if let pokemonEvolves = selectedPokemon.evolvesFrom {
                evolvesLabel.text = pokemonEvolves
            } else {
                evolvesLabel.text = "N/A"
            }
            if let pokemonHP = selectedPokemon.hp {
                hpLabel.text = pokemonHP
            } else {
                hpLabel.text = "N/A HP"
            }
            if let pokemonCardSet = selectedPokemon.cardSet {
                cardSetLabel.text = pokemonCardSet
            } else {
                cardSetLabel.text = "N/A rarity"
            }
            if let allText = selectedPokemon.text {
                pokemonTextLabel.text = allText.joined(separator: " ")
            } else {
                pokemonTextLabel.text = "No text data available"
            }
            if let pokemonArtis = selectedPokemon.artist {
                artisLabel.text = pokemonArtis
            } else {
                artisLabel.text = "N/A"
            }

        }
    }
    
    func setImageFromStringrURL(stringUrl: String) {
        if let url = URL(string: stringUrl) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
          guard let imageData = data else { return }
          DispatchQueue.main.async {
              self.imageView.image = UIImage(data: imageData)
          }
        }.resume()
      }
    }
    

    
    @IBAction func imageUrlTapped(_ sender: Any) {
        let imageURL = pokemon!.imageURL
        if let imageUrl = URL(string: imageURL) {
            if UIApplication.shared.canOpenURL(imageUrl) {
                UIApplication.shared.open(imageUrl, options: [:], completionHandler: nil)
            } else {
                print("cant open")
            }
        }
    }
}
 
