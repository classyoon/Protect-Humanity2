//
//  Civi.swift
//  Protect_Humanity
//
//  Created by Conner Yoon on 7/24/22.
//

import Foundation

struct Civi : MobileEntity, Identifiable {
    mutating func calcDamage(_ mobs: [MobileEntity], vm: WorldVM) -> [MobileEntity] {
        calcDamage(threat: "Z", mobs, Constants.ZombieDamageToCivi, deathFace: "x")
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
                //                                name = "😱"
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

struct Sivi : MobileEntity, Identifiable {
    mutating func calcDamage(_ mobs: [MobileEntity], vm: WorldVM) -> [MobileEntity] {
        calcDamage(threat: "Z", mobs, Constants.ZombieDamageToCivi, deathFace: "s")
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
        calcDamage(threat: "Z", mobs, Constants.ZombieDamageToCivi, deathFace: "D")
        return mobs
    }
    
    var faction = "C"
    var speed = Constants.UniversalCiviSpeed
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
        var rowDelta = 0; var colDelta = 0
        colDelta = Int.random(in: -1...1); rowDelta = Int.random(in: -1...1)
        setTarget(Location(Constants.safeRow(location.row + rowDelta), Constants.safeCol(location.col + colDelta)))
        
        moveTowardsTarget()
        lifespan+=1
        return mobs
    }
}

struct Civi2 : MobileEntity,  Identifiable {
    mutating func calcDamage(_ mobs: [MobileEntity], vm: WorldVM) -> [MobileEntity] {
        calcDamage(threat: "Z", mobs, Constants.ZombieDamageToCivi, deathFace: "2")
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
        calcDamage(threat: "Z", mobs, Constants.ZombieDamageToCivi, deathFace: "C")
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
