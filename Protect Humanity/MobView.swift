//
//  MobView.swift
//  Protect_Humanity
//
//  Created by Conner Yoon on 7/24/22.
//

import SwiftUI
/*
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
 */
struct MobView: View {
    @State var mob: MobileEntity
    @ObservedObject var vm : WorldVM
    var body: some View {
        VStack{
            Text(mob.name)
            Text("\(mob.hp)")
        }
        .font(.title)
        .onTapGesture {vm.handleTap(tapSpot: mob.location)
        }
    }
}

struct MobView_Previews: PreviewProvider {
    static var previews: some View {
        MobView(mob: Zombie(), vm: WorldVM())
    }
}
