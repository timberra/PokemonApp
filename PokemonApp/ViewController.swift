//
//  ViewController.swift
//  PokemonApp
//
//  Created by liga.griezne on 06/11/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewOutlet: UITableView!
    var pokey:[Card] = []
    var filteredPokey: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOutlet.dataSource = self
        tableViewOutlet.delegate = self
        searchBar.delegate = self
        loadPokemonData()
        
    }
    
    func loadPokemonData() {
        let jsonUrl = "https://api.pokemontcg.io/v1/cards"
        guard let url = URL(string: jsonUrl) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        URLSession(configuration: config).dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                do {
                    let jsonData = try JSONDecoder().decode(Pokemon.self, from: data)
                    self.pokey = jsonData.cards
                    
                    DispatchQueue.main.async {
                        self.tableViewOutlet.reloadData()
                    }
                } catch {
                    print("Error:", error)
                }
            }
        }.resume()
    }
    
    func filterPokemons(for searchText: String) {
            filteredPokey = pokey.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            tableViewOutlet.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newIdxArray = pokey.filter { $0.name.lowercased().contains(searchPhrase.lowercased()) }
        if !newIdxArray.isEmpty {
            let selectedPokemon = newIdxArray[indexPath.row]
            performSegue(withIdentifier: "ShowPokemonDetailSegue", sender: selectedPokemon)
        } else {
            let selectedPokemon = pokey[indexPath.row]
            performSegue(withIdentifier: "ShowPokemonDetailSegue", sender: selectedPokemon)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPokemonDetailSegue" {
            if let destinationVC = segue.destination as? PokemonDetailViewController,
               let selectedPokemon = sender as? Card {
                destinationVC.pokemon = selectedPokemon
                
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredPokey.count
        } else {
            return pokey.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        let card: Card
        
        if isSearching {
            card = filteredPokey[indexPath.row]
        } else {
            card = pokey[indexPath.row]
        }
        
        cell.textLabel?.text = card.name
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterPokemons(for: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableViewOutlet.reloadData()
    }
    
    var isSearching: Bool {
        return !searchBar.text!.isEmpty
    }
    
    var searchPhrase: String {
        return searchBar.text ?? ""
    }
}
