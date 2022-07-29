//
//  Mobile Entities.swift
//  Protect_Humanity
//
//  Created by Conner Yoon on 6/19/22.
//

import Foundation
struct Tile : Identifiable {
    var id = UUID()
    var mobileEntities = [MobileEntity]()
    var counter = 0
}
struct Location : Equatable{
    init(_ row : Int, _ col : Int){
        self.row = row
        self.col = col
    }
    init(){
        self.row = 0
        self.col = 0
    }
    var row = 0
    var col = 0
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.row == rhs.row && lhs.col == rhs.col
    }
}

protocol MobileEntity {
    var target : Location { set get }
    var location : Location { set get }
    var id : UUID {set get}
    var hp : Int { set get }
    var name : String {set get}
    var speed : Int {set get}
    var lifespan : Int {set get}
    var faction : String {set get}
    
    mutating func moveTo(_ target : Location)
    mutating func moveTowardsTarget()
    mutating func setTarget(_ newTarget : Location)
    mutating func doMovementBehavior(_ mobs: [MobileEntity], vm: WorldVM) -> [MobileEntity]// inout
    
    mutating func calcDamage(_ mobs: [MobileEntity], vm: WorldVM) -> [MobileEntity]// inout
    func findNearest (_ entity : String, _ mobs : [MobileEntity]) ->(distanceOf: Int, indexOf : Int?, colDistance : Int, rowDistance : Int, rowDifference : Int, colDifference : Int)
}
extension MobileEntity {
    
    mutating func moveTo(_ target : Location){
        location.row = Constants.safeRow(target.row)
        location.col = Constants.safeCol(target.col)
    }
    mutating func moveTowardsTarget(){
        let r = Constants.safeRow(target.row)
        let c = Constants.safeCol(target.col)
        
        var rowOffset = 0, colOffset = 0
        
        let offset = Location(location.row - r, location.col - c)
        switch offset.row {
        case let x where x > 0: rowOffset = -1//up
        case let x where x < 0: rowOffset = 1//down
        default               : rowOffset = 0
        }
        switch offset.col {
        case let x where x > 0: colOffset = -1//left
        case let x where x < 0: colOffset = 1//right
        default               : colOffset = 0
        }
        
        let newRow = Constants.safeRow(location.row+rowOffset), newCol = Constants.safeCol(location.col+colOffset)
        moveTo(Location(newRow, newCol))
        
    }
    mutating func setTarget (_ newTarget: Location) {
        target.col = Constants.safeCol(newTarget.col)
        target.row = Constants.safeRow(newTarget.row)
    }
    func findNearest (_ entity : String, _ mobs : [MobileEntity]) -> (distanceOf: Int, indexOf : Int?, colDistance : Int, rowDistance : Int, rowDifference : Int, colDifference : Int) {
        var shortestDistance : Int = Int.max
        var nearestIndex : Int?
        var finalRowDistance : Int = Int.max
        var finalColDistance : Int = Int.max
        var finalRowDifference : Int = Int.max
        var finalColDifference : Int = Int.max
        
        for index in 0..<mobs.count {
            if mobs[index].faction == entity {
                let absRowDistance = abs(location.row - mobs[index].location.row)
                let absColDistance = abs(location.col - mobs[index].location.col)
                let distance = absRowDistance + absColDistance
                if distance < shortestDistance {
                    shortestDistance = distance
                    nearestIndex = index
                    finalRowDistance = absColDistance
                    finalColDistance = absRowDistance
                    finalRowDifference = mobs[index].location.row - self.location.row
                    finalColDifference = mobs[index].location.col - self.location.col
                }
            }
        }
        //        print("\(entity), Distance : \(shortestDistance), Index : \(nearestIndex), Row Distance: \(finalRowDistance), Col Distance \(finalColDistance), Difference Row : \(finalRowDifference), Difference Col : \(finalColDifference)")
        
        return (shortestDistance, nearestIndex, finalRowDistance, finalColDistance, finalRowDifference, finalColDifference)
    }
    mutating func calcDamage(threat: String, _ mobs : [MobileEntity], _ damageSource: Int, deathFace : String){
        var dangerList = [MobileEntity]()
        for index in 0..<mobs.count {//compiles zombies into list
            if mobs[index].faction==threat{
                dangerList.append(mobs[index])
            }
        }
        for badguy in dangerList {
            if location == badguy.location {
                hp-=damageSource
                print("\(name) : \(hp)")
            }
        }
        if hp <= 0{
            speed = 0
            faction = "Dead"
            print("\(name) : Dead after \(lifespan) Faction set to \(faction)")
            name = deathFace
            print("\(name)")
        }
    }
}

