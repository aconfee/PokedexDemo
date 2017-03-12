//
//  ViewController.swift
//  Pokedex_Demo
//
//  Created by Adam estela on 3/6/17.
//  Copyright © 2017 Adam estela. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collection.dataSource = self
        self.collection.delegate = self
        self.searchBar.delegate = self
        
        self.searchBar.returnKeyType = UIReturnKeyType.done
        
        self.parsePokemonCSV()
        self.initAudio()
    }
    
    func initAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            
            self.musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            self.musicPlayer.prepareToPlay()
            self.musicPlayer.numberOfLoops = -1
            self.musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV(){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                self.pokemon.append(poke)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    // COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Reuse cells that fall off the screen for best perf.
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            let poke = self.inSearchMode ? self.filteredPokemon[indexPath.row] : self.pokemon[indexPath.row]
            cell.configureCell(poke)
            
            return cell
        } else{
            return UICollectionViewCell()
        }
    }
    
    // Will execute when cell is tapped.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let poke = self.inSearchMode ? self.filteredPokemon[indexPath.row] : self.pokemon[indexPath.row]
        
        performSegue(withIdentifier: "PokemonDetailViewController", sender: poke)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.inSearchMode ? self.filteredPokemon.count : pokemon.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105);
    }
    
    // SEARCH BAR
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            self.inSearchMode = false
            self.collection.reloadData()
            view.endEditing(true)
            
        } else {
            self.inSearchMode = true
            
            let searchQuery = searchBar.text!.lowercased()
            self.filteredPokemon = self.pokemon.filter({ $0.Name.lowercased().range(of: searchQuery) != nil })
            self.collection.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailViewController" {
            if let detailsViewController = segue.destination as? PokemonDetailViewController {
                if let poke = sender as? Pokemon {
                    detailsViewController.poke = poke
                }
            }
        }
    }
    
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        
        if self.musicPlayer.isPlaying {
            self.musicPlayer.pause()
            sender.alpha = 0.7
        } else {
            self.musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
}

