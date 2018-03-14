//
//  ValueAnimatorTests.swift
//  ValueAnimatorTests
//
//  Created by hyonsoo han on 2018. 3. 14..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import XCTest
@testable import ValueAnimator

class ValueAnimatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let ani = ValueAnimator.of("p", from: 0, to: 10, duration: 1, onChanged: { p, v in })
        XCTAssertFalse(ani.isAnimating)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
