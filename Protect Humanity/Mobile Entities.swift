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
    var speed : Int {get}
    mutating func moveTo(_ target : Location)
    mutating func moveTowardsTarget()
    mutating func setTarget(_ newTarget : Location)
    mutating func doMovementBehavior(_ mobs: [MobileEntity]) -> [MobileEntity]// inout
    func findNearest (_ entity : String, _ mobs : [MobileEntity]) ->(distanceOf: Int, indexOf : Int?, rowDistance : Int, colDistance : Int, rowDifference : Int, colDifference : Int)
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
        case let x where x > 0: rowOffset = -1
        case let x where x < 0: rowOffset = 1
        default               : rowOffset = 0
        }
        switch offset.col {
        case let x where x > 0: colOffset = -1
        case let x where x < 0: colOffset = 1
        default               : colOffset = 0
        }
        
        let newRow = Constants.safeRow(location.row+rowOffset), newCol = Constants.safeCol(location.col+colOffset)
        moveTo(Location(newRow, newCol))
    }
    mutating func setTarget (_ newTarget: Location) {
        target.col = Constants.safeCol(newTarget.col)
        target.row = Constants.safeRow(newTarget.row)
    }
    func findNearest (_ entity : String, _ mobs : [MobileEntity]) -> (distanceOf: Int, indexOf : Int?, rowDistance : Int, colDistance : Int, rowDifference : Int, colDifference : Int) {
        var shortestDistance : Int = Int.max
        var nearestIndex : Int?
        var finalRowDistance : Int = Int.max
        var finalColDistance : Int = Int.max
        var finalRowDifference : Int = Int.max
        var finalColDifference : Int = Int.max
        for index in 0..<mobs.count {
            if mobs[index].name == entity {
                let rowDistance = abs(location.row - mobs[index].location.row)
                let colDistance = abs(location.col - mobs[index].location.col)
                let distance = rowDistance + colDistance
                if distance < shortestDistance {
                    shortestDistance = distance
                    nearestIndex = index
                    finalRowDistance = colDistance
                    finalColDistance = rowDistance
                    finalRowDifference = mobs[index].location.row - self.location.row
                    finalColDifference = mobs[index].location.col - self.location.col
                }
            }
        }
        if shortestDistance == Int.max {
            shortestDistance = 0
            nearestIndex = 0
            finalRowDistance = 0
            finalColDistance = 0
            finalRowDifference = mobs[0].location.row - self.location.row
            finalColDifference = mobs[0].location.col - self.location.col
        }
        return (shortestDistance, nearestIndex, finalRowDistance, finalColDistance, finalRowDifference, finalColDifference)
    }
    
    
}
struct Zombie : MobileEntity, Identifiable {
    var speed = 1
    var name = "🧟"
    var id = UUID()
    var target: Location = Location()
    var location: Location = Location()
    var hp: Int = 5
    var attacking : Bool = false
    mutating func doMovementBehavior(_ mobs: [MobileEntity])->[MobileEntity]{
        if hp <= 0{
            speed = 0
            name = "o"
        }
        for index in 0..<mobs.count {
            if (mobs[index].name == "🪖") && (mobs[index].location == location) {
                hp -= 3
                if Int.random(in: 0...1) == 1{
                    print("Stunned")
                    return mobs
                }
            }
        }
        
        let prey = findNearest("😃", mobs)
        if prey.distanceOf == Int.max {
            return mobs
        }
        if let index = prey.indexOf {
            setTarget(mobs[index].location)
            moveTowardsTarget()
        }
        return mobs
    }
}
var UniversalCiviSpeed = 1
struct Civi : MobileEntity, Identifiable {
    var speed = UniversalCiviSpeed
    var name = "😃"
    var id = UUID()
    var target: Location = Location()
    var location: Location = Location()
    var hp: Int = 5
    var lifespan = 0
    mutating func doMovementBehavior(_ mobs: [MobileEntity])->[MobileEntity]{
        let danger = findNearest("🧟", mobs)
        //        print("I am scared of \(danger.distanceOf)")
        if let index = danger.indexOf {
            if mobs[index].location==location && !(hp<=0) {
                hp-=1
            }
        }
        if hp <= 0{
            speed = 0
            name = "x"
            print("Civi : Dead after \(lifespan)")
        }
        if danger.distanceOf < Int.max {
            var rowDelta = 0
            var colDelta = 0
            
            switch danger.rowDistance {
            case 0:
                rowDelta = Int.random(in: 0...1) == 0 ? -1 : 1
//                name = "😱"
            case 1...3:
                rowDelta = danger.rowDifference < 0 ? -1 : 1
//                name = "☹️"
            case 4...8 :
                rowDelta = Int.random(in: 0...1)
//                name = "😖"
            default :
                rowDelta = Int.random(in: -1...1)
//                name = "😃"
            }
            switch danger.colDistance {
            case 0:
                colDelta = Int.random(in: 0...1) == 0 ? -1 : 1
//                name = "😱"
            case 1...3:
                colDelta = danger.colDifference < 0 ? -1 : 1
//                name = "☹️"
            case 4...8 :
                colDelta = Int.random(in: 0...1)
//                name = "😖"
            default:
                colDelta = Int.random(in: -1...1)
//                name = "😃"
            }
            setTarget(Location(Constants.safeRow(location.row + rowDelta), Constants.safeCol(location.col + colDelta)))
            
        }
        
        moveTowardsTarget()
        lifespan+=1
        return mobs
        
        
        
    }
}

struct Soldier : MobileEntity, Identifiable {
    var targetID : UUID?
    var id = UUID()
    var target: Location = Location()
    var location: Location = Location()
    var hp = 10
    var name = "🪖"
    var speed = 1
    var targetLock = false
    
    mutating func doMovementBehavior(_ mobs: [MobileEntity]) -> [MobileEntity] {
        if targetLock {
            for mob in mobs {
                if (mob.id==targetID)&&(mob.name == "🧟") {
                    setTarget(mob.location)
                }
            }
        }
        moveTowardsTarget()
        return mobs
    }
    
}
struct Sivi : MobileEntity, Identifiable {
    var speed = UniversalCiviSpeed
    var name = "😃"
    var id = UUID()
    var target: Location = Location()
    var location: Location = Location()
    var hp: Int = 5
    var lifespan = 0
    mutating func doMovementBehavior(_ mobs: [MobileEntity])->[MobileEntity]{
        let danger = findNearest("🧟", mobs)
        if let index = danger.indexOf {
            if mobs[index].location==location && mobs[index].name=="🧟" && !(hp==0) {
                hp-=1
            }
        }
        if hp == 0{
            speed = 0
            name = "s"
            print("Sivi : Dead after \(lifespan)")
        }
     
            var rowDelta = 0
            var colDelta = 0
            
            if let index = danger.indexOf {
                if mobs[index].location == location {
                    rowDelta = Int.random(in: 0...1) == 0 ? -1 : 1
                    colDelta = Int.random(in: 0...1) == 0 ? -1 : 1
//                    print("\(lifespan) X")
                }
                else if danger.rowDistance==1{
                    colDelta = danger.colDifference < 0 ? 1 : -1
                    rowDelta = Int.random(in: -1...1)
//                    print("\(lifespan) r")
                }
                else if danger.colDistance==1{
                    colDelta = Int.random(in: -1...1)
                    rowDelta = danger.rowDifference < 0 ? 1 : -1
                   // print("\(lifespan) c")
                }
            else {
                colDelta = Int.random(in: -1...1)
                rowDelta = Int.random(in: -1...1)
            }
            }
            setTarget(Location(Constants.safeRow(location.row + rowDelta), Constants.safeCol(location.col + colDelta)))
        
        moveTowardsTarget()
        lifespan+=1
        return mobs
        
        
        
    }
}

struct Dummy : MobileEntity, Identifiable {
    var speed = UniversalCiviSpeed
    var name = "😃"
    var id = UUID()
    var target: Location = Location()
    var location: Location = Location()
    var hp: Int = 5
    var lifespan = 0
    mutating func doMovementBehavior(_ mobs: [MobileEntity])->[MobileEntity]{
        let danger = findNearest("🧟", mobs)
        //        print("I am scared of \(danger.distanceOf)")
        if let index = danger.indexOf {
            if mobs[index].location==location && !(hp==0) {
                hp-=1
            }
        }
        if hp == 0{
            speed = 0
            name = "d"
            print("Dummy : Dead after \(lifespan)")
        }
        var rowDelta = 0
        var colDelta = 0
            colDelta = Int.random(in: -1...1)
            rowDelta = Int.random(in: -1...1)
            setTarget(Location(Constants.safeRow(location.row + rowDelta), Constants.safeCol(location.col + colDelta)))
            
        
        
        moveTowardsTarget()
        lifespan+=1
        return mobs
        
        
        
    }
}
/**
 if danger.rowDistance == 0 && danger.colDistance == 0
 rowDelta = Int.random(in: 0...1) == 0 ? -1 : 1
 colDelta = Int.random(in: 0...1) == 0 ? -1 : 1
 
 if danger.rowDistance==1
 rowDelta = danger.rowDifference < 0 ? 1 : -1
 colDelta = Int.random(in: -1...1)
 
 if danger.colDistance==1
 rowDelta = Int.random(in: -1...1)
 colDelta = danger.colDifference < 0 ? 1 : -1
 
 if danger.colDistance==1 && danger.rowDistance==1
 if danger.rowDistance==1
 rowDelta = danger.rowDifference < 0 ? 1 : -1
 colDelta = Int.random(in: -1...1)
 
 if danger.colDistance==1
 rowDelta = Int.random(in: -1...1)
 colDelta = danger.colDifference < 0 ? 1 : -1
 
 
 
 random = Int.random(in: 0...1) == 0 ? -1 : 1
 
 
 
 
 
 
 if rowDifference==1
 col minus
 random row
 
 if rowDifference==-1
 col plus
 random row
 
 if both rowDifference and col Difference greater than 0
 randomly choose between either
 row plus and random col
 or
 col plus and random row
 or both
 
 if both rowDifference and col Difference less than 0
 randomly choose between either
 row minus and random col
 or
 col minus and random row
 or both
 
 if  rowDifference less than 0 but col Difference greater than 0
 randomly choose between either
 row minus and random col
 or
 col plus and random row
 or both
 
 */
