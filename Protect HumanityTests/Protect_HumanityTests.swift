//
//  Protect_HumanityTests.swift
//  Protect HumanityTests
//
//  Created by Conner Yoon on 6/19/22.
//

import XCTest
@testable import Protect_Humanity


class Protect_HumanityTests: XCTestCase {
    func testCalcDamageTests() throws {
        var sut = Zombie()
        let vm = WorldVM()
        var mobs: [MobileEntity] = []
        let tick = Tick()
        
        mobs.append(sut)
        sut.hp = -1
        mobs = sut.calcDamage(mobs, vm: vm)
        mobs = sut.doMovementBehavior(mobs, vm: vm)
        tick.doTick(&mobs, vm: vm)
        mobs = sut.calcDamage(mobs, vm: vm)
        mobs = sut.doMovementBehavior(mobs, vm: vm)
        tick.doTick(&mobs, vm: vm)
        
        XCTAssertEqual(sut.speed, 0)
        XCTAssertEqual(sut.name, "o")
    }

}
