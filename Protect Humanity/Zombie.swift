//
//  Zombie.swift
//  Protect_Humanity
//
//  Created by Conner Yoon on 7/24/22.
//

import Foundation
struct Zombie : MobileEntity, Identifiable {
    
    var faction = "Z"
    var speed = Constants.ZombieSpeed
    var name = "🧟"
    var id = UUID()
    var target: Location = Location()
    var location: Location = Location()
    var hp: Int = 5
    var attacking : Bool = false
    var lifespan = 0
    mutating func calcDamage(_ mobs: [MobileEntity], vm: WorldVM) -> [MobileEntity] {
        //        print("OW")
        calcDamage(threat: "S", mobs, Constants.SoldierDamageToZom, deathFace: "o")
        return mobs
    }
    
    mutating func doMovementBehavior(_ mobs: [MobileEntity], vm: WorldVM)->[MobileEntity]{
        lifespan+=1
        
        let prey = findNearest("C", mobs)
        
        if let index = prey.indexOf {
            if mobs[index].faction == "C"{
                if (Int.random(in: 0...1)==1) {
                    setTarget(mobs[index].location)
                    moveTowardsTarget()
                }
            }
        }
        else{
            var rowDelta = 0; var colDelta = 0
            colDelta = Int.random(in: -1...1); rowDelta = Int.random(in: -1...1)
            setTarget(Location(Constants.safeRow(location.row + rowDelta), Constants.safeCol(location.col + colDelta)))
            moveTowardsTarget()
            return mobs
        }
        
        return mobs
    }
}
