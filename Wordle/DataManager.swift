//
//  DataManager.swift
//  Wordle
//
//  Created by Jonathan French on 26.10.22.
//

import Foundation
import CoreData
import SwiftUI

class DataManager {
    
    var userManager:UserManager
    
    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Wordle")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return Self.persistentContainer.viewContext
    }
    
    var coordinator: NSPersistentStoreCoordinator {
        return Self.persistentContainer.persistentStoreCoordinator
    }
    
    init(userManager:UserManager){
        print("init DataManager")
        self.userManager = userManager
    }
    
    func addGame() {
        let winner = userManager.winner
        if let playerStats = userManager.playerStats {
            let fetchRequest: NSFetchRequest<GameStats> = GameStats.fetchRequest()
            let predicate = NSPredicate(format: "id == %i", 1)
            fetchRequest.predicate = predicate
            context.perform {
                do {
                    let result = try fetchRequest.execute()
                    if let newStats = result.first {
                        newStats.lastUpdated = Date()
                        if winner {
                            if playerStats.currentStreak >= playerStats.maxStreak {
                                newStats.maxStreak = playerStats.maxStreak + 1
                            }
                            newStats.currentStreak = playerStats.currentStreak + 1
                        } else {
                            newStats.currentStreak = 0
                            newStats.lostGames = playerStats.lostGames + 1
                            newStats.maxStreak = playerStats.maxStreak
                        }
                        self.userManager.playerStats = newStats
                    }
                } catch {
                    print("Unable to Execute Fetch Request, \(error)")
                }
            }
            
            let newItem = Games(context: context)
            newItem.timestamp = Date()
            newItem.word = userManager.gameWords.todaysWord
            if winner {
                newItem.tries = Int64(userManager.currentLine) + 1
            }
            newItem.success = winner
            saveContext()
        }
    }
    
    func seed() {
//        let words = GameWords()
        print("Seeding")
        //Seed Stats
        let newStats = GameStats(context: context)
        newStats.lastUpdated = Date()
        newStats.maxStreak = 0
        newStats.currentStreak = 0
        newStats.lostGames = 0
        newStats.id = 1
        //Seed games
        //        for _ in 0..<200 {
        //            let newItem = Games(context: context)
        //            newItem.timestamp = Date()
        //            newItem.word = words.getWord()
        //            let res = Int64(Int.random(in: 1...6))
        //            if res == 6 {
        //                newItem.success = false
        //            } else {
        //                newItem.success = true
        //            }
        //            newItem.tries = Int64(Int.random(in: 1...6))
        //        }
        
        saveContext()
    }
    
    func saveContext () {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func clearData (entity:String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchStats() {
        let fetchRequest: NSFetchRequest<GameStats> = GameStats.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", 1)
        fetchRequest.predicate = predicate
        context.perform {
            
            do {
                let result = try fetchRequest.execute()
                if result.count == 0 {
                    self.seed()
                    self.fetchStats()
                } else {
                    self.userManager.playerStats = result.first
                }
            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
    }
    
    func fetchGames() {
        let fetchRequest: NSFetchRequest<Games> = Games.fetchRequest()
        context.perform {
            do {
                var gameStats = [0,0,0,0,0,0]
                let result = try fetchRequest.execute()
                
                let count = result.count
                if count > 0 {
                    let counts = result.reduce(into: [:]) { counts,game in counts[game.tries, default: 0] += 1 }
                    for i in 1...6 {
                        if let num = counts[Int64(i)] {
                            gameStats[i-1] = num
                        }
                    }
                    print("Games \(count) Results \(counts) Stats \(gameStats)")
                }
                self.userManager.gameStats = gameStats
                self.userManager.gamesPlayed = count
                
            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
    }
    
    func update() {
        self.addGame()
        self.fetchStats()
        self.fetchGames()
    }
}
