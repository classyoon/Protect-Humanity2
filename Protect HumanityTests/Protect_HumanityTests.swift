//
//  Protect_HumanityTests.swift
//  Protect HumanityTests
//
//  Created by Conner Yoon on 6/19/22.
//

import XCTest
@testable import Protect_Humanity

class Protect_HumanityTests: XCTestCase {

    func testLocationInitialization() throws {
        let sut = Location(row: 1, col: 3)
        
        XCTAssertEqual(sut.row, 1)
        XCTAssertEqual(sut.col, 3)
    }

    func testMoveToLocationThatDoesNotNeedSafeRowOrSafeCol() throws {
        // Given
        var sut = Zombie()
        	
        // When
        sut.moveTo(target: Location(row: 1, col: 3))
        
        // Then
        XCTAssertEqual(sut.location.row, 1)
        XCTAssertEqual(sut.location.col, 3)
    }
    func testMoveToLocationThaNeedsSafeRowOrSafeCol() throws {
        // Given
        var sut = Zombie()
            
        // When
        sut.moveTo(target: Location(row: Constants.rowMax + 1, col:Constants.colMax + 3 ))
        
        // Then
        XCTAssertEqual(sut.location.row, 1)
        XCTAssertEqual(sut.location.col, 3)
    }

    func testMoveTowardsExample1 () throws {
        var sut = Zombie()
        sut.moveTo(target: Location(row: 0, col: 0  ))
        sut.setTarget(newTarget: Location(row: 0, col: 0))
        
        XCTAssertEqual(sut.location.row, 0)
        XCTAssertEqual(sut.location.col, 0)

        sut.setTarget(newTarget: Location(row: 0, col: 1))
        sut.moveTowardsTarget()
        XCTAssertEqual(sut.location.row, 0)
        XCTAssertEqual(sut.location.col, 1)
        
        sut.setTarget(newTarget: Location(row: 1, col: 2))
        sut.moveTowardsTarget()
        XCTAssertEqual(sut.location.row, 1)
        XCTAssertEqual(sut.location.col, 2)
        
    }
    func testMoveTowardsExample2 () throws {
        var sut = Zombie()
        sut.moveTo(target: Location(row: 0, col: 0  ))
        sut.setTarget(newTarget: Location(row: 0, col: 0))
        
        XCTAssertEqual(sut.location.row, 0)
        XCTAssertEqual(sut.location.col, 0)

        sut.setTarget(newTarget: Location(row: 0, col: 3))
        sut.moveTowardsTarget()
        sut.moveTowardsTarget()
        sut.moveTowardsTarget()
        
        XCTAssertEqual(sut.location.row, 0)
        XCTAssertEqual(sut.location.col, 3)
        
    }

    func testZombieMovementBehavior() throws {
        let civi = Civi(target: Location(row: 5, col: 3), location: Location(row: 5, col: 3))
        var sut = Zombie(target: Location(row: 0, col: 0), location: Location(row: 0, col: 0))
        
        var mobs : [MobileEntity] = [
        sut, civi
        ]
    
        mobs = sut.doMovementBehavior(mobs: mobs)
        mobs = sut.doMovementBehavior(mobs: mobs)
        mobs = sut.doMovementBehavior(mobs: mobs)
        mobs = sut.doMovementBehavior(mobs: mobs)
        mobs = sut.doMovementBehavior(mobs: mobs)
        
       
        XCTAssertEqual(sut.location.row, 5)
        XCTAssertEqual(sut.location.col, 3)
    }
    func testCiviMovementBehavior() throws {
        var sut = Civi(target: Location(row: 0, col: 1), location: Location(row: 0, col: 1))
        let zombie = Zombie(target: Location(row: 0, col: 0), location: Location(row: 0, col: 0))
        
        var mobs : [MobileEntity] = [
        zombie, sut
        ]
    
        mobs = sut.doMovementBehavior(mobs: mobs)
       
        XCTAssertEqual(sut.location.row, 1)
        XCTAssertEqual(sut.location.col, 2)
    }
    
}
