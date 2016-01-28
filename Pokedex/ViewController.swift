//
//  ViewController.swift
//  Pokedex
//
//  Created by Eric Townsend on 1/27/16.
//  Copyright © 2016 KrimsonTech. All rights reserved.
//

import UIKit
import AVFoundation //used for music

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]() //got the searchbar to store filtered pokemon after we type
    var musicPlayer: AVAudioPlayer! // creates the audio player
    var inSearchMode = false // are we typing in the search bar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done //changes the end keyboard name to Done
        
        parsePokemonCSV() //calls the func at view did load
        initAudio() // starts the music when view loads
    }
    
    func initAudio() {
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay() //starts them music player
            musicPlayer.numberOfLoops = -1 //plays the song over and over
            musicPlayer.play()
            
        } catch let err as NSError {
                print(err.debugDescription)
        }
        
    }
    
        // grabs the pokemon data from the CSV file
    func parsePokemonCSV() {
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        //finding the path of the items
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
        //takes the stuff out of the CSV file dictionary
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
            print(rows)
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
     
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            
            cell.configureCell(poke)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //when a cell is clicked this is where the data pushes over
        
        let poke: Pokemon!
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
            
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode{
            return filteredPokemon.count
        } else {
            
        return pokemon.count
     }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105,105)
    }
    
    //when the done button is clicked it hides the keyboard
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    //search bar functionality to make it filter throught the pokemon
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true) //hides the keyboard if nothing is in the search bar
            collectionView.reloadData()
            
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil}) //$0 means that it grabs the element out of the array and names it 0
                                                                                    //rangeOfString checks the name to see if the letters are there
            collectionView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" { // tells which VC your going into
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC { //cast it to VC
                if let poke = sender as? Pokemon { //grabs object that you pass as sender
                    detailsVC.pokemon = poke //putting that in the VC
                }
            }
        }
    }
    
    @IBAction func musicButtonPressed (sender: UIButton!) {
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2 // transperant
        } else {
            musicPlayer.play()
            sender.alpha = 1.0 //returns the color to the button
        }
    }
 
}
