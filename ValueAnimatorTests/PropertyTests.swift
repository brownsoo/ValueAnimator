import XCTest
@testable import ValueAnimator

class PropertyTests: XCTestCase {
    
    private var animator: ValueAnimator!
    private let duration: TimeInterval = 1
    
    override func setUp() {
        super.setUp()
        animator = ValueAnimator.animate("p", from: 0, to: 10, duration: duration)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        animator.dispose()
        super.tearDown()
    }
    
    func testIsAnimatingAtFirst() {
        XCTAssertFalse(animator.isAnimating)
        XCTAssertFalse(animator.isDisposed)
        XCTAssertFalse(animator.isFinished)
    }
    
    func testIsAnimatingAtResume() {
        animator.resume()
        XCTAssertTrue(animator.isAnimating)
        XCTAssertFalse(animator.isDisposed)
        XCTAssertFalse(animator.isFinished)
    }
    
    func testIsAnimatingInDuration() {
        let expectation = XCTestExpectation(description:"Check isAnimating in duration time")
        animator.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + duration - 0.5) {
            XCTAssertTrue(self.animator.isAnimating)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: duration * 2)
    }
    
    func testIsAnimatingAfterDuration() {
        let expectation = XCTestExpectation(description:"Check isAnimating in duration time")
        animator.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.5) {
            XCTAssertTrue(self.animator.isAnimating == false)
            XCTAssertTrue(self.animator.isFinished)
            XCTAssertTrue(self.animator.isDisposed == false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: duration * 2)
    }
    
}
