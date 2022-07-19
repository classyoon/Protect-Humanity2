//
//  WorldVM.swift
//  Protect_Humanity
//
//  Created by Conner Yoon on 6/19/22.
//

import Foundation

class WorldVM : ObservableObject {
    @Published var mobs : [MobileEntity] = []
    @Published var grid = [[Tile]]()
    var isUnitSelected = false
    var firstTap = true
    var selectedSoldier : Soldier?
    func clockTick(){
        decrementCounterInTiles()
    }
    private func decrementCounterInTiles(){
        for row in 0..<grid.count {
            for col in 0..<grid[0].count {
                let counter = grid[row][col].counter
                grid[row][col].counter = counter <= 0 ? 0 : counter - 1
            }
        }
    }
    func markLocation(row: Int, col: Int){
        grid[row][col].counter = Constants.trailCount
    }
    func handleTap (tapSpot : Location){// location gets selected on the board
        
        
        if firstTap{
            //issue command
            //            print("first tap")
            //
            for mob in mobs {
                if (mob.name=="🪖")&&(mob.location==tapSpot) {
                    //select soldier underneath location and notify slection
                    selectedSoldier = (mob as! Soldier)
                    //                    print("Awaiting Orders")
                    
                    firstTap = false
                    break
                }
                
            }
            
        }else{
            //            print("Second tap")
            for mob in mobs {
                if (mob.name=="🧟")&&(mob.location==tapSpot) {//checks if second tap is a zombie
                    // assert(mobs[selectedSoldier].name == "🪖")
                    if var selectedSoldier = selectedSoldier {
                        selectedSoldier.targetID = mob.id
                        selectedSoldier.targetLock = true
                        // Change the mob in mobs to have same value as selectedSolder
                        setSoldierInMobs(soldier: selectedSoldier)
                        //                        print("It works! Target lock : \(selectedSoldier.targetLock)")
                    }
                    break
                }
                else {
                    //issue target
                    if var selectedSoldier = selectedSoldier {
                        print("You shouldn't see this")
                        selectedSoldier.setTarget(tapSpot)
                        setSoldierInMobs(soldier: selectedSoldier)
                    }
                }
            }
        }
    }
    private func setSoldierInMobs(soldier : Soldier){
        for index in 0..<mobs.count {
            if soldier.id == mobs[index].id {
                mobs[index] = soldier
                print("Checking Mobs \(mobs[index])")
                firstTap = true
                break
            }
        }
    }
    
    func statusTile(_ row: Int, _ col: Int){
        
    }
    
    let randomLoc: () ->Location = {Location(Int.random(in: 0...Constants.rowMax-1), Int.random(in: 0...Constants.colMax-1))}
    
    let center: () ->Location = { Location(Constants.rowMax/2, Constants.colMax/2)}
    let centerLeft: () ->Location = { Location(Constants.rowMax/2, 0)}
    let centerRight: () ->Location = { Location(Constants.rowMax/2, Constants.colMax-1)}
    
    let topCenter: () ->Location = {Location(0, Constants.colMax/2)}
    let topLeft: () ->Location = { Location(0, 0)}
    let topRight: () ->Location = { Location(0, Constants.colMax-1)}
    
    let bottomCenter: () ->Location = {Location(Constants.rowMax-1, Constants.colMax/2)}
    let bottomLeft: () ->Location = {Location(Constants.rowMax-1, 0)}
    let bottomRight: () ->Location = {Location(Constants.rowMax-1, Constants.colMax-1)}
    
    init(){
        grid = Array(repeating: Array(repeating: Tile(), count: Constants.colMax), count: Constants.rowMax)
        
        
        
        
        //                    mobs.append(Zombie(location: center()))
        //GLITCH ONE
        //        mobs.append(Sivi(location: Location(1, 1)))
        //        mobs.append(Soldier(target: Location(2, 2), location: Location(2, 2)))
        //Glitch TWO
        //
        //                mobs.append(Soldier(target: centerLeft(), location: centerLeft()))
        
        //        mobs.append(Sivi(location: randomLoc()))
        //                    mobs.append(Civi(location:  randomLoc()))//Is able to run away
        //                    mobs.append(Dummy(location: randomLoc()))//Literally a single braincell
        //        mobs.append(Sivi(location: randomLoc()))
        //                    mobs.append(Civi(location:  randomLoc()))//Is able to run away
        //                    mobs.append(Dummy(location: randomLoc()))//Literally a single braincell
        mobs.append(Sivi(location: randomLoc()))
        //                    mobs.append(Civi(location:  randomLoc()))//Is able to run away
        //                    mobs.append(Dummy(location: randomLoc()))//Literally a single braincell
        
        
        //                mobs.append(Soldier(location: randomLoc()))
        //                mobs.append(Soldier(location: randomLoc()))
        
        mobs.append(Civi(location: randomLoc()))
        mobs.append(Dummy(location: randomLoc()))
      
        mobs.append(Civi2(location: randomLoc()))
        mobs.append(Zombie(location: randomLoc()))
        mobs.append(Zombie(location: randomLoc()))
    
        
    }
}

