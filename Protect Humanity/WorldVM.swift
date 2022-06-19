//
//  WorldVM.swift
//  Protect_Humanity
//
//  Created by Conner Yoon on 6/19/22.
//

import Foundation

class WorldVM : ObservableObject {
    @Published var mobs : [MobileEntity] = []
    @Published var grid = [[Tile]]()
    
    
    func statusTile(row: Int, col: Int){
        
    }
    init(){
        grid = Array(repeating: Array(repeating: Tile(), count: Constants.colMax), count: Constants.rowMax)
        
        mobs.append(Zombie(location: Location(row: 4, col: 3)))
        mobs.append(Civi(location: Location(row: 0, col: 0)))
//        mobs.append(Zombie(location: Location(row: 5, col: 1)))
        mobs[0].setTarget(newTarget: Location(row: 2, col: 2))
        mobs[1].setTarget(newTarget: Location(row: 0, col: 0))
//        mobs[2].setTarget(newTarget: Location(row: 1, col: 2))
    }
}
