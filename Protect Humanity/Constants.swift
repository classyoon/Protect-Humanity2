//
//  Constants.swift
//  Protect_Humanity
//
//  Created by Conner Yoon on 6/19/22.
//

import Foundation
struct Constants {
    static let colMax = 9
    static let rowMax = 9
    static var UniversalCiviSpeed = 1
    static var ZombieSpeed = 1
    static var ZombieDamageToCivi = 1
    static var SoldierDamageToZom = 3
    static let trailCount = 0
    static var GenerationTimer = 0
    static var GenerationDuration = 40
    static var GenerationNumber = 0
    static var Evolution = true
    
    static let center: () ->Location = { Location(Constants.rowMax/2, Constants.colMax/2)}
    static let centerLeft: () ->Location = { Location(Constants.rowMax/2, 0)}
    static let centerRight: () ->Location = { Location(Constants.rowMax/2, Constants.colMax-1)}
    
    static let topCenter: () ->Location = {Location(0, Constants.colMax/2)}
    static let topLeft: () ->Location = { Location(0, 0)}
    static let topRight: () ->Location = { Location(0, Constants.colMax-1)}
    
    static let bottomCenter: () ->Location = {Location(Constants.rowMax-1, Constants.colMax/2)}
    static let bottomLeft: () ->Location = {Location(Constants.rowMax-1, 0)}
    static let bottomRight: () ->Location = {Location(Constants.rowMax-1, Constants.colMax-1)}
    
    static let randomLoc: () ->Location = {Location(Int.random(in: 0...Constants.rowMax-1), Int.random(in: 0...Constants.colMax-1))}
    
    
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
