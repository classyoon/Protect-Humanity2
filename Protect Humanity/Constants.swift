//
//  Constants.swift
//  Protect_Humanity
//
//  Created by Conner Yoon on 6/19/22.
//

import Foundation
struct Constants {
    static let colMax = 10
    static let rowMax = 10
    static var UniversalCiviSpeed = 1
    static var ZombieSpeed = 1
    static var ZombieDamageToCivi = 1
    static var SoldierDamageToZom = 2
    static let trailCount = 0 
    
    static func safeRow(_ row: Int)-> Int {//INOUT????
        //        let r = row % rowMax
        if row < 0 {
            return 0//r + rowMax
        }
        if row>rowMax-1{
            return rowMax-1
        }
        return row
    }
    static func safeCol(_ col: Int)-> Int {
        // let c = col % colMax
        if col < 0 {
            return 0//c + colMax
        }
        if col>colMax-1{
            return colMax-1
        }
        return col
    }
    /**
     static func safeCol(_ col: inout Int) {
     col = col % colMax
     if col < 0 {
     col+=colMax
     }
     }
     */
    static func hypotenus(row: Int, col: Int) -> Double{
        sqrt( Double(row*row + col*col))
    }
    
}
