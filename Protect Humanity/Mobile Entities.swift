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
}
struct Location : Equatable{
    var row = 0
    var col = 0
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.row == rhs.row && lhs.col == rhs.col
    }
}
protocol MobileEntity {
    var target : Location { set get }
    var location : Location { set get }
    var hp : Int { set get }
    var name : String {get}
    var speed : Int {get}
    mutating func moveTo(target : Location)
    mutating func moveTowardsTarget()
    mutating func setTarget(newTarget : Location)
    mutating func doMovementBehavior(mobs: [MobileEntity]) -> [MobileEntity]
}
extension MobileEntity {

    mutating func moveTo(target : Location){
        location.row = Constants.safeRow(row: target.row)
        location.col = Constants.safeCol(col: target.col)
    }
    mutating func moveTowardsTarget(){
        let r = Constants.safeRow(row: target.row)
        let c = Constants.safeCol(col: target.col)
        
        var rowOffset = 0
        var colOffset = 0
        
        let offset = Location(row: location.row - r, col: location.col - c)
        switch offset.row {
        case let x where x > 0:
            rowOffset = -1
        case let x where x < 0:
            rowOffset = 1
        default :
            rowOffset = 0
        }
        switch offset.col {
        case let x where x > 0:
            colOffset = -1
        case let x where x < 0:
            colOffset = 1
        default :
            colOffset = 0
        }
        
        let newRow = Constants.safeRow(row: location.row+rowOffset)
        let newCol = Constants.safeCol(col: location.col+colOffset)
        moveTo(target: Location(row: newRow, col: newCol))
    }
    mutating func setTarget (newTarget: Location) {
        target.col = Constants.safeCol(col: newTarget.col)
        target.row = Constants.safeRow(row: newTarget.row)
    }

}
struct Zombie : MobileEntity, Identifiable {
    var speed = 1
    var name = "🧟"
    var id = UUID()
    var target: Location = Location()
    var location: Location = Location()
    var hp: Int = 5
    mutating func doMovementBehavior(mobs: [MobileEntity])->[MobileEntity]{
        var mobs = mobs
        for index in 0..<mobs.count {
            if mobs[index].name == "😃"{
                setTarget(newTarget: mobs[index].location)
                mobs[index] = self
            }
        }
        moveTowardsTarget()
        
        return mobs
    }
}
struct Civi : MobileEntity, Identifiable {
    var speed = 1
    var name = "😃"
    var id = UUID()
    var target: Location = Location()
    var location: Location = Location()
    var hp: Int = 5
    mutating func doMovementBehavior(mobs: [MobileEntity])->[MobileEntity]{
        var shortestDistance : Int = Int.max
        var nearestIndex : Int = Int.max
        for index in 0..<mobs.count {
            if mobs[index].name == "🧟" {
                let rowDistance = abs(location.row - mobs[index].location.row)
                let colDistance = abs(location.col - mobs[index].location.col)
                let distance = rowDistance + colDistance
                if distance < shortestDistance {
                    shortestDistance = distance
                    nearestIndex = index
                    print("Zombie is close!!! About \(distance) meters away!")
                }
            }
        }
        if shortestDistance < Int.max {
            let mob = mobs[nearestIndex]
            var rowDelta = 0
            var colDelta = 0
            let rowDifference = mob.location.row - self.location.row
            let colDifference = mob.location.col - self.location.col
            
            if shortestDistance < 6 {
                if rowDifference < 3 {
                    rowDelta = Int.random(in: 0...1) == 0 ? -1 : 1
                }
//                else {
//                    rowDelta = (rowDifference < 0) ? 1 : -1
//                }
                if colDifference < 3 {
                    colDelta = Int.random(in: 0...1) == 0 ? -1 : 1
                }
//                    else {
//                    colDelta = (colDifference < 0) ? 1 : -1
//                }
                setTarget(newTarget: Location(row: rowDelta, col: colDelta))
            }
        }
        moveTowardsTarget()
        return mobs
    }
}
