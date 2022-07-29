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
                            getViewOfMobsAt(row, col).frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        
                    }
                }
            }
        }
        
    }
//    func getViewOfMobsAt(_ row: Int, _ col: Int) -> some View {
//        var mobNames = ""
//        for mob in vm.mobs {
//            if mob.location.row == row &&
//                mob.location.col == col{
//                mobNames += mob.name + " "
//            }
//        }
//        return Text(mobNames).font(.system(size: 40))
//    }
    func getMobView(mob: MobileEntity) -> some View {
//        return Text(mob.name)
        return MobView(mob: mob, vm: vm)
    }
    func getViewOfMobsAt(_ row: Int, _ col: Int) -> some View {
        let mobs = getAllMobsAtLocation(Location(row, col))
        return HStack{
            ForEach(0..<mobs.count, id: \.self) { index in
                getMobView(mob: mobs[index])
            }
        }
        
    }
    func getAllMobsAtLocation(_ TargetLocation : Location) ->[MobileEntity]{
        var mobs : [MobileEntity] = []
        for mob in vm.mobs {
            if mob.location == TargetLocation {
                mobs.append(mob)
            }
        }
        return mobs
    }
    
    
}
struct ContentView: View {
    @State var turns = 0
    @State var isPlaying = false//.8
    var timer = Timer.publish(every:0.5  , on: .main, in: .common).autoconnect()
    @StateObject var vm = WorldVM()
    @State var CiviPoints = 0
    @State var SiviPoints = 0
    
    
    
    private func doTick(_ mobs : inout [MobileEntity]){
        for index in 0..<vm.mobs.count {
            for _ in 0..<vm.mobs[index].speed {
                mobs = vm.mobs[index].doMovementBehavior(vm.mobs, vm: vm)
            }
        }
        //calculate damage all at once
        for index in 0..<vm.mobs.count {
            mobs = vm.mobs[index].calcDamage(vm.mobs, vm: vm)
        }
        vm.clockTick()
        if Constants.Evolution == true {
            Constants.GenerationTimer+=1
            if   Constants.GenerationTimer==Constants.GenerationDuration{
                Constants.GenerationNumber+=1
                var survivors = [MobileEntity]()
                for mob in vm.mobs {
                    switch mob.name {
                    case "😃":
                        survivors.append(Civi(location: Constants.randomLoc()))
                        survivors.append(Civi(location: Constants.randomLoc()))
                    case "😐":
                        survivors.append(Dummy(location: Constants.randomLoc()))
                        survivors.append(Dummy(location: Constants.randomLoc()))
                    case "🥸":
                        survivors.append(Carlo(location: Constants.randomLoc()))
                        survivors.append(Carlo(location: Constants.randomLoc()))
                    case "🤓":
                        survivors.append(Sivi(location: Constants.randomLoc()))
                        survivors.append(Sivi(location: Constants.randomLoc()))
                    case "👦🏼":
                        survivors.append(Civi2(location: Constants.randomLoc()))
                        survivors.append(Civi2(location: Constants.randomLoc()))
                    case "🪖":
                        survivors.append(Soldier(location: Constants.randomLoc()))
                    default :
                        continue
                    }
                    
                }
                mobs.removeAll()
                
                for _ in 0..<survivors.count/2 {
                    survivors.append(Zombie(location: Constants.randomLoc()))
                }
                
                
                mobs = survivors
                Constants.GenerationTimer=0
            }
        }
    }
    var body: some View {
        VStack {
            ZStack{
                WorldView(vm: vm)
                GridView(vm: vm)
            }
            .onReceive(timer) { _ in
                if isPlaying {
                    doTick(&vm.mobs)
                }
            }
            HStack{
                Button {
                    isPlaying.toggle()
                } label: {
                    Text(isPlaying ? "Stop" : "Play")
                }
                Button {
                    doTick(&vm.mobs)
                } label: {
                    Text("Next")
                }
                Button {
                    vm.mobs.removeAll()
                    vm.addEntities()
                } label: {
                    Text("Restart")
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
