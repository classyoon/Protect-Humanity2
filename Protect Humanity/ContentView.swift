//
//  ContentView.swift
//  Protect Humanity
//
//  Created by Conner Yoon on 6/15/22.
//


import SwiftUI


struct WorldView: View {
    @ObservedObject var vm : WorldVM
    
    private func opacityCalcuator(row: Int, col: Int) -> Double {
        Double(vm.grid[row][col].counter) / Double(Constants.trailCount)
    }
    
    var body: some View {
        VStack{
            ForEach(0..<Constants.rowMax, id:\.self){ row in
                HStack{
                    ForEach(0..<Constants.colMax, id:\.self){ col in
                        ZStack{
                            Rectangle().fill(Color.green)
                                .overlay(Color.red.opacity(opacityCalcuator(row: row, col: col)))
                                .onTapGesture {
                                    vm.handleTap(tapSpot: Location(row, col))
                                }
                        }
                    }
                }
            }
        }
    }
}


struct GridView: View {
    @ObservedObject var vm : WorldVM
    let increment = 5
    let barHeight = 10
    var body: some View {
        VStack{
            ForEach(0..<Constants.rowMax, id:\.self){ row in
                HStack{
                    ForEach(0..<Constants.colMax, id:\.self){ col in
                        ZStack{
                            Rectangle() .fill(Color.clear)
                                .onTapGesture {
                                    //                                    $vm.handleTap(tapSpot: Location(row, col))
                                }
                            getMobView(row, col).frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        
                    }
                }
            }
        }
        
    }
    func getMobView(_ row: Int, _ col: Int) -> some View {
        var mobNames = ""
        for mob in vm.mobs {
            if mob.location.row == row &&
                mob.location.col == col{
                mobNames += mob.name + " "
            }
        }
        return Text(mobNames).font(.system(size: 40))
    }
    
    
}
struct ContentView: View {
    @State var turns = 0
    @State var isPlaying = false//.8
    var timer = Timer.publish(every:1  , on: .main, in: .common).autoconnect()
    @StateObject var vm = WorldVM()
    @State var CiviPoints = 0
    @State var SiviPoints = 0
    
    
    
    var body: some View {
        VStack {
            ZStack{
                WorldView(vm: vm)
                GridView(vm: vm)
            }
            .onReceive(timer) { _ in
                if isPlaying {
                    for index in 0..<vm.mobs.count {
                        for _ in 0..<vm.mobs[index].speed {
                            _ = vm.mobs[index].doMovementBehavior(vm.mobs, vm: vm)
                        }
                    }
                    //calculate damage all at once
                    for index in 0..<vm.mobs.count {
                            _ = vm.mobs[index].calcDamage(vm.mobs, vm: vm)
                    }
                    vm.clockTick()
                }
            }
            HStack{
                Button {
                    isPlaying.toggle()
                } label: {
                    Text(isPlaying ? "Stop" : "Play")
                }
                Button {
                    for index in 0..<vm.mobs.count {
                        for _ in 0..<vm.mobs[index].speed {
                            //                            if (vm.mobs[index].name == "x" && vm.mobs[index].name == "o"){
                            //                                vm.mobs.remove(at: index)
                            //                            }
                            _ = vm.mobs[index].doMovementBehavior(vm.mobs, vm: vm)
                            
                        }
                    }
                    //calculate damage all at once
                    for index in 0..<vm.mobs.count {
                            _ = vm.mobs[index].calcDamage(vm.mobs, vm: vm)
                    }
                    
                } label: {
                    Text("Next")
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
