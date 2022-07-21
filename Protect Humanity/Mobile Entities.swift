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
    var speed : Int {get}
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
        if shortestDistance == Int.max {
            shortestDistance = 0
            nearestIndex = 0
            finalRowDistance = 0
            finalColDistance = 0
            finalRowDifference = mobs[0].location.row - self.location.row
            finalColDifference = mobs[0].location.col - self.location.col
        }
        //        print("\(entity), Distance : \(shortestDistance), Index : \(nearestIndex), Row Distance: \(finalRowDistance), Col Distance \(finalColDistance), Difference Row : \(finalRowDifference), Difference Col : \(finalColDifference)")
        
        return (shortestDistance, nearestIndex, finalRowDistance, finalColDistance, finalRowDifference, finalColDifference)
    }
    func calcDamage(_ name: inout String, faction : inout String, enemy: String, _ mobs : [MobileEntity], _ hp : inout Int, _ damageSource: Int, _ speed : inout Int, deathFace : String){
//        print("Thinking")
          var dangerList = [MobileEntity]()
          for index in 0..<mobs.count {//compiles zombies into list
              if mobs[index].faction==enemy{
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
              faction = "x"
              print("\(name) : Dead after \(lifespan)")
              name = deathFace
          }
      }
}


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
        calcDamage(&name, faction: &faction, enemy: "S", mobs, &hp, Constants.SoldierDamageToZom, &speed, deathFace: "o")
        return mobs
    }
    
    mutating func doMovementBehavior(_ mobs: [MobileEntity], vm: WorldVM)->[MobileEntity]{
        lifespan+=1
      
        let prey = findNearest("C", mobs)
        if prey.distanceOf == Int.max {
            target = Location(location.row+Int.random(in: -1...1), location.col+Int.random(in: -1...1))
            moveTowardsTarget()
            return mobs
        }
        else if let index = prey.indexOf {
            if (Int.random(in: 0...1)==1) {
                setTarget(mobs[index].location)
                moveTowardsTarget()
            }
                else{
                return mobs
            }
        }
        
        
        return mobs
    }
}

struct Civi : MobileEntity, Identifiable {
    mutating func calcDamage(_ mobs: [MobileEntity], vm: WorldVM) -> [MobileEntity] {
        calcDamage(&name, faction: &faction, enemy: "Z", mobs, &hp, Constants.ZombieDamageToCivi, &speed, deathFace: "x")
        return mobs
    }
    
    var faction = "C"
    var speed = Constants.UniversalCiviSpeed
    var name = "😃"
    var id = UUID()
    var target: Location = Location()
    var location: Location = Location()
    var hp: Int = 5
    var lifespan = 0
    private func markLocation(vm: WorldVM){
        vm.markLocation(row: location.row, col: location.col)
    }
    mutating func doMovementBehavior(_ mobs: [MobileEntity], vm: WorldVM)->[MobileEntity]{
        let danger = findNearest("Z", mobs)
        markLocation(vm: vm)
        
        //        print("I am scared of \(danger.distanceOf)")
      
        var ZList = [MobileEntity]()
        for index in 0..<mobs.count {//compiles zombies into list
            if mobs[index].faction=="Z"{
                ZList.append(mobs[index])
            }
        }

        
        
        if danger.distanceOf < Int.max {
            var rowDelta = 0
            var colDelta = 0
            
            switch danger.rowDistance {
            case 0:
                rowDelta = Int.random(in: 0...1) == 0 ? 1 : -1
                //                name = "😱"
            case 1...3:
                rowDelta = danger.rowDifference < 0 ? 1 : -1
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
                colDelta = Int.random(in: 0...1) == 0 ? 1 : -1
                //                name = "😱"
            case 1...3:
                colDelta = danger.colDifference < 0 ? 1 : -1
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
    mutating func calcDamage(_ mobs: [MobileEntity], vm: WorldVM) -> [MobileEntity] {
        calcDamage(&name, faction: &faction, enemy: "Z", mobs, &hp, 1, &speed, deathFace: "*")
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

struct Sivi : MobileEntity, Identifiable {
    mutating func calcDamage(_ mobs: [MobileEntity], vm: WorldVM) -> [MobileEntity] {
        calcDamage(&name, faction: &faction, enemy: "Z", mobs, &hp, Constants.ZombieDamageToCivi, &speed, deathFace: "S")
        return mobs
    }
    
    var faction = "C"
    
    var speed = Constants.UniversalCiviSpeed
    //var name = "😃"
    var name = "🤓"
    var id = UUID()
    var target: Location = Location()
    var location: Location = Location()
    var hp: Int = 5
    var lifespan = 0
    var tags = 0
    private func markLocation(vm: WorldVM){
        vm.markLocation(row: location.row, col: location.col)
    }
    mutating func doMovementBehavior(_ mobs: [MobileEntity], vm: WorldVM)->[MobileEntity]{
        //        print("Sivi")
        markLocation(vm: vm)
        let danger = findNearest("Z", mobs)
        var ZList = [MobileEntity]()
        for index in 0..<mobs.count {//compiles zombies into list
            if mobs[index].faction=="Z"{
                ZList.append(mobs[index])
            }
        }

        
        var rowDelta = 0
        var colDelta = 0
        
        if let index = danger.indexOf {
            if mobs[index].location == location {
                rowDelta = Int.random(in: 0...1) == 0 ? -1 : 1
                colDelta = Int.random(in: 0...1) == 0 ? -1 : 1
                tags+=1
                //                print("\(lifespan), I got tagged \(tags)")
                //name = "X"
                //   print("\(lifespan) X Going r: \(rowDelta), c: \(colDelta)")
            }
            else if (danger.colDistance==1||danger.colDistance==2)&&(danger.rowDistance==1||danger.rowDistance==2) {
                colDelta = danger.colDifference < 0 ? 1 : -1
                rowDelta = danger.rowDifference < 0 ? 1 : -1
                //                print("\(lifespan) D trigger row \(danger.rowDistance) col \(danger.colDistance) Factors r: \(danger.rowDifference), c: \(danger.colDifference)")
                //                print("\(lifespan) D response r: \(rowDelta), c: \(colDelta)")
                //  name = "D"
                
            }
            else if danger.colDistance==1{
                rowDelta =  Int.random(in: 0...1)
                colDelta =  danger.colDistance < 0 ? 1 : -1
                
                //                print("\(lifespan) C trigger \(danger.colDistance) Factors c: \(danger.colDifference)")
                
                //                print("\(lifespan) C Going r: \(rowDelta), c: \(colDelta)")
                //  name = "C"
            }
            else if danger.rowDistance==1{
                colDelta = Int.random(in: -1...1)
                rowDelta = danger.rowDifference < 0 ? 1 : -1
                //                print("\(lifespan) R trigger \(danger.rowDistance) Factors r: \(danger.rowDifference), c: \(danger.colDifference)")
                //                print("\(lifespan) R Going r: \(rowDelta), c: \(colDelta)")
                //name = "R"
            }
            else {
                colDelta = Int.random(in: -1...1)
                rowDelta = Int.random(in: -1...1)
                //                print("\(lifespan) N Going r: \(rowDelta), c: \(colDelta)")
                //                print("\(lifespan) Trigger row \(danger.rowDistance) col \(danger.colDistance) b")
                // name = "🤓"
            }
        }
        //        print("(Location(Constants.safeRow(location.row + rowDelta), Constants.safeCol(location.col + colDelta)))")
        setTarget(Location(Constants.safeRow(location.row + rowDelta), Constants.safeCol(location.col + colDelta)))
        //        print(target)
        moveTowardsTarget()
       
        lifespan+=1
        return mobs
        
        
        
    }
}

struct Dummy : MobileEntity, Identifiable {
    mutating func calcDamage(_ mobs: [MobileEntity], vm: WorldVM) -> [MobileEntity] {
        calcDamage(&name, faction: &faction, enemy: "Z", mobs, &hp, Constants.ZombieDamageToCivi, &speed, deathFace: "D")
        return mobs
    }
    
    var faction = "C"
    var speed = Constants.UniversalCiviSpeed
    //var name = "😃"
    var name = "😐"
    var id = UUID()
    var target: Location = Location()
    var location: Location = Location()
    var hp: Int = 5
    var lifespan = 0
    private func markLocation(vm: WorldVM){
        vm.markLocation(row: location.row, col: location.col)
    }
    mutating func doMovementBehavior(_ mobs: [MobileEntity], vm: WorldVM)->[MobileEntity]{
        markLocation(vm: vm)
        var ZList = [MobileEntity]()
        for index in 0..<mobs.count {//compiles zombies into list
            if mobs[index].faction=="Z"{
                ZList.append(mobs[index])
            }
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


struct Civi2 : MobileEntity,  Identifiable {
    mutating func calcDamage(_ mobs: [MobileEntity], vm: WorldVM) -> [MobileEntity] {
        calcDamage(&name, faction: &faction, enemy: "Z", mobs, &hp, Constants.ZombieDamageToCivi, &speed, deathFace: "2")
        return mobs
    }
    
//    let directions = [location
    var target = Location()
    var location = Location()
    var id = UUID()
    var hp = 5
    var name = "👦🏼"
    var speed = Constants.UniversalCiviSpeed
    var lifespan = 0
    var faction = "C"
    
    mutating func doMovementBehavior(_ mobs: [MobileEntity], vm: WorldVM) -> [MobileEntity] {

        
        let left = Constants.safeCol(location.col - speed)//Dynamic range finding
        let right = Constants.safeCol(location.col + speed)
        let above = Constants.safeRow(location.row - speed)
        let below = Constants.safeRow(location.row + speed)
        
        let riskPenalty = 1
        let safeSpotBonus = 1
        var ZList = [MobileEntity]()
        var bestScore = -100
        var bestLocation = [location]
//print("Turn \(lifespan)-----------")
        
        for index in 0..<mobs.count {//compiles zombies into list
            if mobs[index].faction=="Z"{
                ZList.append(mobs[index])
            }
        }
        for y in above..<below+1{//Neighboring spots
            for x in left..<right+1{
                
                var safetyScore = 0
                
                // Risk Penalty Calculation
                for zom in 0..<ZList.count{
        
                    if ((abs(ZList[zom].location.row-y)<=1)&&(abs(ZList[zom].location.col-x)<=1)){
                        safetyScore-=riskPenalty
//                        print("X: \(x) Y:\(y) Risk Penalty")
                    }
                    
                }
                
                // Safe possibility bonus calculation
                for futy in Constants.safeRow(y-speed)..<Constants.safeRow(y+speed)+1{//Sets score of neighboring spots by looking at future spots
                    for futx in Constants.safeCol(x-speed)..<Constants.safeCol(x+speed)+1{
                        var zombieNear = false
                        for zom in 0..<ZList.count{ //check if ANY ZOMBIE is near the possible spot
                            if ((abs(ZList[zom].location.row-(futy))<=1)&&(abs(ZList[zom].location.col-(futx))<=1)){
//                                print("Fut X: \(futx) Fut Y:\(futy) bad spot")
                                zombieNear=true
                            }
                        }
                        if (zombieNear){
//                            print("Fut X: \(futx) Fut Y:\(futy) bad spot")
                        }
                        else{
                            safetyScore+=safeSpotBonus
//                            print("Fut X: \(futx) Fut Y:\(futy) possible spot")
                        }
                      
                    }
                    
                }
//                print("X: \(x) Y:\(y) Safety: \(safetyScore)")
                if safetyScore>bestScore{
                    bestScore=safetyScore
                    bestLocation=[Location(y,x)]
//                    print("Best Score \(bestScore)")
//                    print("Best Location \(bestLocation)")
                    
                }
                else if safetyScore==bestScore{
                    bestLocation.append(Location(y,x))
                }
            }
        }
        

        setTarget(bestLocation[Int.random(in: 0...bestLocation.count-1)])
        
        moveTowardsTarget()

        lifespan+=1
        return mobs
    }
    
    
}
struct Carlo : MobileEntity, Identifiable  {
    mutating func calcDamage(_ mobs: [MobileEntity], vm: WorldVM) -> [MobileEntity] {
        calcDamage(&name, faction: &faction, enemy: "Z", mobs, &hp, Constants.ZombieDamageToCivi, &speed, deathFace: "C")
        return mobs
    }
    
    var target = Location()
    var location = Location()
    var id = UUID()
    var hp = 5
    var name = "🥸"
    var speed = Constants.UniversalCiviSpeed
    var lifespan = 0
    var faction = "C"
    
    mutating func doMovementBehavior(_ mobs: [MobileEntity], vm: WorldVM) -> [MobileEntity] {
        var ZList = [MobileEntity]()
        for index in 0..<mobs.count {//compiles zombies into list
            if mobs[index].faction=="Z"{
                ZList.append(mobs[index])
            }
        }
        
        let left = Constants.safeCol(location.col - speed)//Dynamic range finding
        let right = Constants.safeCol(location.col + speed)
        let above = Constants.safeRow(location.row - speed)
        let below = Constants.safeRow(location.row + speed)
        
        let riskPenalty = 1
        var bestScore = -100
        var bestLocation = [location]
//print("Turn \(lifespan)-----------")

        for y in above..<below+1{//Neighboring spots
            for x in left..<right+1{
                var safetyScore = 0
                for index in 0..<ZList.count {

                    let absRowDistance = abs(y - ZList[index].location.row)
                    let absColDistance = abs(x - ZList[index].location.col)
                    if (absRowDistance==1&&absColDistance==0)||(absRowDistance==0&&absColDistance==1)||(absRowDistance==1&&absColDistance==1){
                        safetyScore-=riskPenalty
                    }
                    if(absRowDistance==0&&absColDistance==0){
                        safetyScore-=riskPenalty*2
                    }
                    
                }
                if safetyScore>bestScore{
                    bestScore=safetyScore
                    bestLocation=[Location(y,x)]
//                    print("Best Score \(bestScore)")
//                    print("Best Location \(bestLocation)")
                    
                }
                else if safetyScore==bestScore{
                    bestLocation.append(Location(y,x))
                }
                
            }

        }
        setTarget(bestLocation[Int.random(in: 0...bestLocation.count-1)])
        
        moveTowardsTarget()

        lifespan+=1
        
        return mobs
    }
    
    
}
