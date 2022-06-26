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
    func handleTap (tapSpot : Location){// location gets selected on the board
        if firstTap{
            //issue command
            print("first tap")
            //
            for mob in mobs {
                if (mob.name=="🪖")&&(mob.location==tapSpot) {
                    //select soldier underneath location and notify slection
                    selectedSoldier = mob as! Soldier
                    print("Awaiting Orders")
                    firstTap = false
                    break
                }
                
            }
            
        }else{
            print("Second tap")
            for mob in mobs {
                if (mob.name=="🧟")&&(mob.location==tapSpot) {//checks if second tap is a zombie
                    // assert(mobs[selectedSoldier].name == "🪖")
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
    init(){
        grid = Array(repeating: Array(repeating: Tile(), count: Constants.colMax), count: Constants.rowMax)
        
        mobs.append(Zombie(location: Location(2, 0)))
                mobs.append(Zombie(location: Location(3, 0)))
//                mobs.append(Zombie(location: Location(2, 0)))
        //        mobs.append(Sivi(location: Location(2, 2)))
        //        mobs.append(Soldier(target : Location(0, 2), location: Location(0, 2)))
                mobs.append(Soldier(location: Location(2, 3)))
        mobs.append(Soldier(location: Location(1, 9)))
        
//        mobs.append(Civi(location: Location(9, 9)))//
        mobs.append(Sivi(location: Location(9, 9)))
        //        mobs.append(Civi(location: Location(9, 9)))//has a death wish
                mobs.append(Sivi(location: Location(9, 9)))//Is able to run away
        //        mobs.append(Dummy(location: Location(9, 9)))//Literally a single braincell
        //        mobs.append(Dummy(location: Location(9, 9)))
//                mobs.append(Zombie(location: Location(5, 1)))
        
    }
}

