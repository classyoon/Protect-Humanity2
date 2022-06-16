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
            return
                lhs.row == rhs.row &&
                lhs.col == rhs.col
        }
}
protocol MobileEntity {
    var target : Location { set get }
    var location : Location { set get }
    var hp : Int { set get }
}
struct Zombie : MobileEntity, Identifiable {
    var id = UUID()
    var target: Location = Location()
    var location: Location = Location()
    var hp: Int = 5
}

class WorldVM : ObservableObject {
    @Published var mobs : [MobileEntity] = []
    @Published var grid = [[Tile]]()
    static let colMax = 3
    static let rowMax = 6
    
    func statusTile(row: Int, col: Int){
        
    }
    init(){
        grid = Array(repeating: Array(repeating: Tile(), count: WorldVM.colMax), count: WorldVM.rowMax)
        
//        grid[0][1].mobileEntities.append(Zombie(location: Location(row: 2, col: 1)))
        mobs.append(Zombie(location: Location(row: 2, col: 1)))
    }
}
struct WorldView: View {
    @ObservedObject var vm : WorldVM
    var body: some View {
        VStack{
            ForEach(0..<WorldVM.rowMax, id:\.self){ row in
                HStack{
                    ForEach(0..<WorldVM.colMax, id:\.self){ col in
                        ZStack{
                            Rectangle() .fill(Color.green)
                            .onTapGesture {
                            }
//                            if (vm.grid[row][col].mobileEntities.count != 0) {
//                                Text("Mobile")
//                            }
                        }
        
                    }
                }
            }
        }
    }
}

struct GridView: View {
    @ObservedObject var vm : WorldVM
    var body: some View {
        VStack{
            ForEach(0..<WorldVM.rowMax, id:\.self){ row in
                HStack{
                    ForEach(0..<WorldVM.colMax, id:\.self){ col in
                        ZStack{
                            Rectangle() .fill(Color.clear)
                            .onTapGesture {
                            }
                            getMobView(row: row, col: col)
                        }
        
                    }
                }
            }
        }
    }
    func getMobView(row: Int, col: Int) -> some View {
        for mob in vm.mobs {
            if mob.location.row == row &&
                mob.location.col == col{
                return Text("Mobile")
            }
        }
        return Text("Test")
    }
}
struct ContentView: View {
    @StateObject var vm = WorldVM()
    
    var body: some View {
        ZStack{
//            WorldView(vm: vm)
            GridView(vm: vm)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
