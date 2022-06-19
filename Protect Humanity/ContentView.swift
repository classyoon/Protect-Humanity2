//
//  ContentView.swift
//  Protect Humanity
//
//  Created by Conner Yoon on 6/15/22.
//


import SwiftUI


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
        return Text(mobNames).font(.system(size: 40))
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
