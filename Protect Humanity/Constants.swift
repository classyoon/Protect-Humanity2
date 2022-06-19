//
//  Constants.swift
//  Protect_Humanity
//
//  Created by Conner Yoon on 6/19/22.
//

import Foundation
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
