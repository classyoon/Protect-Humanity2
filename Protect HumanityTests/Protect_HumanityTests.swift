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
        let sut = Location(1, 3)
        
        XCTAssertEqual(sut.row, 1)
        XCTAssertEqual(sut.col, 3)
    }

    func testMoveToLocationThatDoesNotNeedSafeRowOrSafeCol() throws {
        // Given
        var sut = Zombie()
        	
        // When
        sut.moveTo(Location(1, 3))
        
        // Then
        XCTAssertEqual(sut.location.row, 1)
        XCTAssertEqual(sut.location.col, 3)
    }
    func testMoveToLocationThaNeedsSafeRowOrSafeCol() throws {
        // Given
        var sut = Zombie()
            
        // When
        sut.moveTo(Location(Constants.rowMax + 1, Constants.colMax + 3 ))
        
        // Then
        XCTAssertEqual(sut.location.row, 1)
        XCTAssertEqual(sut.location.col, 3)
    }

    func testMoveTowardsExample1 () throws {
        var sut = Zombie()
        sut.moveTo(Location(0, 0  ))
        sut.setTarget(Location(0, 0))
        
        XCTAssertEqual(sut.location.row, 0)
        XCTAssertEqual(sut.location.col, 0)

        sut.setTarget(Location(0, 1))
        sut.moveTowardsTarget()
        XCTAssertEqual(sut.location.row, 0)
        XCTAssertEqual(sut.location.col, 1)
        
        sut.setTarget(Location(1, 2))
        sut.moveTowardsTarget()
        XCTAssertEqual(sut.location.row, 1)
        XCTAssertEqual(sut.location.col, 2)
        
    }
    func testMoveTowardsExample2 () throws {
        var sut = Zombie()
        sut.moveTo(Location(0, 0  ))
        sut.setTarget(Location(0, 0))
        
        XCTAssertEqual(sut.location.row, 0)
        XCTAssertEqual(sut.location.col, 0)

        sut.setTarget(Location(0, 3))
        sut.moveTowardsTarget()
        sut.moveTowardsTarget()
        sut.moveTowardsTarget()
        
        XCTAssertEqual(sut.location.row, 0)
        XCTAssertEqual(sut.location.col, 3)
        
    }

    func testZombieMovementBehavior() throws {
        let civi = Civi(target: Location(5, 3), location: Location(5, 3))
        var sut = Zombie(target: Location(0, 0), location: Location(0, 0))
        
        var mobs : [MobileEntity] = [
        sut, civi
        ]
    
//        mobs = sut.doMovementBehavior(mobs)
//        mobs = sut.doMovementBehavior(mobs)
//        mobs = sut.doMovementBehavior(mobs)
//        mobs = sut.doMovementBehavior(mobs)
//        mobs = sut.doMovementBehavior(mobs)
        
       
        XCTAssertEqual(sut.location.row, 5)
        XCTAssertEqual(sut.location.col, 3)
    }
    func testCiviMovementBehavior() throws {
        var sut = Civi(target: Location(0, 1), location: Location(0, 1))
        let zombie = Zombie(target: Location(0, 0), location: Location(0, 0))
        
        var mobs : [MobileEntity] = [
        zombie, sut
        ]
    
//        mobs = sut.doMovementBehavior(mobs)
       
        XCTAssertEqual(sut.location.row, 1)
        XCTAssertEqual(sut.location.col, 1)
    }
    
}
