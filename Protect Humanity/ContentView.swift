//
//  ContentView.swift
//  Protect Humanity
//
//  Created by Conner Yoon on 6/15/22.
//


import SwiftUI
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
        target.col = newTarget.col
        target.row  = newTarget.row
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
            setTarget(newTarget: Location(row: Constants.safeRow(row: mobs[nearestIndex].location.row + Constants.rowMax/2),col: Constants.safeCol(col:mobs[nearestIndex].location.col + Constants.colMax/2)))
        }
        moveTowardsTarget()
        return mobs
    }
}

struct Constants {
    static let colMax = 9
    static let rowMax = 11
    static func safeRow(row: Int)-> Int {
        let r = row % Constants.rowMax
        if r < 0 {
            return r + Constants.rowMax
        }
        return r
    }
   static func safeCol(col: Int)-> Int {
       let c = col % Constants.colMax
       if c < 0 {
           return c + Constants.colMax
       }
       return c
    }
    static func hypotenus(row: Int, col: Int) -> Double{
        sqrt( Double(row*row + col*col))
    }
}

class WorldVM : ObservableObject {
    @Published var mobs : [MobileEntity] = []
    @Published var grid = [[Tile]]()
    
    
    func statusTile(row: Int, col: Int){
        
    }
    init(){
        grid = Array(repeating: Array(repeating: Tile(), count: Constants.colMax), count: Constants.rowMax)
        
        mobs.append(Zombie(location: Location(row: 10, col: 10)))
        mobs.append(Civi(location: Location(row: 0, col: 0)))
//        mobs.append(Zombie(location: Location(row: 5, col: 1)))
        mobs[0].setTarget(newTarget: Location(row: 2, col: 2))
        mobs[1].setTarget(newTarget: Location(row: 0, col: 0))
//        mobs[2].setTarget(newTarget: Location(row: 1, col: 2))
    }
}
struct WorldView: View {
    @ObservedObject var vm : WorldVM
    var body: some View {
        VStack{
            ForEach(0..<Constants.rowMax, id:\.self){ row in
                HStack{
                    ForEach(0..<Constants.colMax, id:\.self){ col in
                        ZStack{
                            Rectangle() .fill(Color.green)
                                .onTapGesture {
                                }
                                                        
                        }
                        
                    }
                }
            }
            Button {
                for index in 0..<vm.mobs.count {
                _ = vm.mobs[index].doMovementBehavior(mobs: vm.mobs)
                }
            } label: {
                Text("Do Something")
            }

        }
    }
}

struct GridView: View {
    @ObservedObject var vm : WorldVM
    var body: some View {
        VStack{
            ForEach(0..<Constants.rowMax, id:\.self){ row in
                HStack{
                    ForEach(0..<Constants.colMax, id:\.self){ col in
                        ZStack{
                            Rectangle() .fill(Color.clear)
                                .onTapGesture {
                                }
                            getMobView(row: row, col: col).frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        
                    }
                }
            }
        }
    }
    func getMobView(row: Int, col: Int) -> some View {
        var mobNames = ""
        for mob in vm.mobs {
            if mob.location.row == row &&
                mob.location.col == col{
                mobNames += mob.name + " "
            }
        }
        return Text(mobNames).font(.system(size: 60))
    }
}
struct ContentView: View {
    @StateObject var vm = WorldVM()
    
    var body: some View {
        ZStack{
            WorldView(vm: vm)
            GridView(vm: vm)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
