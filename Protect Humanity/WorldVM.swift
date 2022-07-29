//
//  WorldVM.swift
//  Protect_Humanity
//
//  Created by Conner Yoon on 6/19/22.
//

import Foundation

class Tick{
    func doTick(_ mobs : inout [MobileEntity], vm: WorldVM){
        for index in 0..<vm.mobs.count {
            for _ in 0..<vm.mobs[index].speed {
                mobs = vm.mobs[index].doMovementBehavior(vm.mobs, vm: vm)
            }
        }
        //calculate damage all at once
        for index in 0..<vm.mobs.count {
            mobs = vm.mobs[index].calcDamage(vm.mobs, vm: vm)
        }
        vm.clockTick()
        if Constants.Evolution == true {
            Constants.GenerationTimer+=1
            if   Constants.GenerationTimer==Constants.GenerationDuration{
                Constants.GenerationNumber+=1
                var survivors = [MobileEntity]()
                for mob in vm.mobs {
                    if (mob.faction=="C"){
                        survivors.append(mob)
                        survivors.append(mob)
                    }
                    if (mob.faction=="S"){
                        survivors.append(mob)
                    }
                }
                mobs.removeAll()
                
                for _ in 0..<survivors.count/2 {
                    survivors.append(Zombie(location: Constants.randomLoc()))
                }
                
                
                mobs = survivors
                Constants.GenerationTimer=0
            }
        }
    }
}

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
    func handleTap(mob: MobileEntity){
        /*
         use the mob.id to find the index at mobs that corresponds to the given mob
         if index is not found then return from this function without doing anythinng
         given an index then modify the correct mob in the mobs to do what you want
         */
        let index = mobs.firstIndex { arrayMob in
            arrayMob.id == mob.id
        }
        
        guard let index = index else {
            return
        }
        mobs[index].hp += 1
        
    }
    func handleTap(tapSpot : Location){// location gets selected on the board
        if firstTap{
            //issue command
            print("first tap")
            //
            for mob in mobs {
                if (mob.name=="🪖"){
                    //select soldier underneath location and notify slection
                    selectedSoldier = (mob as! Soldier)
                    print("Awaiting Orders")
                    
                    firstTap = false
                    break
                }
                
            }
            
        }else{
            //            print("Second tap")
            for mob in mobs {
                if (mob.name=="🧟"){//checks if second tap is a zombie
                    if var selectedSoldier = selectedSoldier {
                        selectedSoldier.targetID = mob.id
                        selectedSoldier.targetLock = true
                        // Change the mob in mobs to have same value as selectedSolder
                        setSoldierInMobs(soldier: selectedSoldier)
                        print("It works! Target lock : \(selectedSoldier.targetLock)")
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
    func setSoldierInMobs(soldier : Soldier){
        for index in 0..<mobs.count {
            if soldier.id == mobs[index].id {
                mobs[index] = soldier
                print("Checking Mobs \(mobs[index])")
                firstTap = true
                break
            }
        }
    }
    func addEntities(){
        for _ in 0..<2 {
//            mobs.append(Soldier(location: Constants.randomLoc()))
                        mobs.append(Dummy(location: Constants.randomLoc()))//Literally a single braincell
                        mobs.append(Civi(location:  Constants.randomLoc()))//Is able to run away
                        mobs.append(Sivi(location: Constants.randomLoc()))
                        mobs.append(Carlo(location: Constants.randomLoc()))
                        mobs.append(Civi2(location: Constants.randomLoc()))
            
        }
        
        //            mobs.append(Zombie(location: Constants.randomLoc()))
        mobs.append(Zombie(location: Constants.randomLoc()))
    }
    
    
    func statusTile(_ row: Int, _ col: Int){
        
    }
    
    
    init(){
        grid = Array(repeating: Array(repeating: Tile(), count: Constants.colMax), count: Constants.rowMax)
        addEntities()
    }
}

