//
//  Soldier.swift
//  Protect_Humanity
//
//  Created by Conner Yoon on 7/24/22.
//

import Foundation

struct Soldier : MobileEntity, Identifiable {
    mutating func calcDamage(_ mobs: [MobileEntity], vm: WorldVM) -> [MobileEntity] {
        //        calcDamage(&name, faction: &faction, threat: "Z", mobs, &hp, 1, &speed, deathFace: "*")
        return mobs
    }
    
    var faction = "S"
    var lifespan = 0
    
    var targetID : UUID?
    var id = UUID()
    public var target: Location = Location()
    var location: Location = Location()
    var hp = 10
    var name = "🪖"
    var speed = 1
    var targetLock = false
    
    mutating func doMovementBehavior(_ mobs: [MobileEntity], vm: WorldVM) -> [MobileEntity] {
        if targetLock {
            for mob in mobs {
                if (mob.id==targetID)&&(mob.faction == "Z") {
                    setTarget(mob.location)
                }
            }
        }
        moveTowardsTarget()
        
        return mobs
    }
}


