import XCTest
@testable import ValueAnimator

class ConcurrentAnimationTests: XCTestCase {

    override func tearDown() {
        ValueAnimator.disposeAll()
        super.tearDown()
    }

    // MARK: - Multiple animations running simultaneously

    func testMultipleAnimationsAllFinish() {
        let count = 5
        let duration: TimeInterval = 0.5
        let expectations = (0..<count).map {
            XCTestExpectation(description: "Animation \($0) finished")
        }

        for i in 0..<count {
            let ani = ValueAnimator.animate(
                "prop\(i)", from: 0, to: 100, duration: duration,
                onChanged: nil
            )
            ani.endCallback = { expectations[i].fulfill() }
            ani.resume()
        }

        wait(for: expectations, timeout: duration + 1.0)
    }

    func testMultipleAnimationsReceiveCorrectValues() {
        let duration: TimeInterval = 0.5
        var receivedA = [ValueAnimatable]()
        var receivedB = [ValueAnimatable]()
        let doneA = XCTestExpectation(description: "A done")
        let doneB = XCTestExpectation(description: "B done")

        let a = ValueAnimator.animate(
            "a", from: 0, to: 100, duration: duration,
            easing: EaseLinear.easeNone(),
            onChanged: { _, v in receivedA.append(v) }
        )
        a.endCallback = { doneA.fulfill() }

        let b = ValueAnimator.animate(
            "b", from: 100, to: 0, duration: duration,
            easing: EaseLinear.easeNone(),
            onChanged: { _, v in receivedB.append(v) }
        )
        b.endCallback = { doneB.fulfill() }

        a.resume()
        b.resume()

        wait(for: [doneA, doneB], timeout: duration + 1.0)

        // A should have ended near 100, B near 0
        if let lastA = receivedA.last {
            XCTAssertGreaterThan(lastA.d, 90, "Animation A should approach 100")
        }
        if let lastB = receivedB.last {
            XCTAssertLessThan(lastB.d, 10, "Animation B should approach 0")
        }
    }

    // MARK: - Rapid creation and disposal

    func testRapidCreateAndDispose() {
        let iterations = 20
        let expectation = XCTestExpectation(description: "All rapid animations handled")

        for i in 0..<iterations {
            let ani = ValueAnimator.animate(
                "rapid\(i)", from: 0, to: 1, duration: 0.3
            )
            ani.resume()
            // Dispose half immediately, let the other half run
            if i % 2 == 0 {
                ani.dispose()
            }
        }

        // Wait and verify no crash
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: - Concurrent creation from multiple threads

    func testConcurrentCreationFromMultipleThreads() {
        let count = 10
        let group = DispatchGroup()
        let duration: TimeInterval = 0.5
        let endExpectations = (0..<count).map {
            XCTestExpectation(description: "Concurrent animation \($0) finished")
        }

        for i in 0..<count {
            group.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                let ani = ValueAnimator.animate(
                    "concurrent\(i)", from: 0, to: 50, duration: duration
                )
                ani.endCallback = { endExpectations[i].fulfill() }
                ani.resume()
                group.leave()
            }
        }

        // All animations should complete without crash
        wait(for: endExpectations, timeout: duration + 2.0)
    }

    // MARK: - Mixed operations (pause, resume, finish) across animations

    func testMixedOperationsOnConcurrentAnimations() {
        let duration: TimeInterval = 1.0
        let finishedExp = XCTestExpectation(description: "Finished animation ended")
        let resumedExp = XCTestExpectation(description: "Resumed animation ended")

        let aniPause = ValueAnimator.animate("pause", from: 0, to: 10, duration: duration)
        let aniFinish = ValueAnimator.animate("finish", from: 0, to: 10, duration: duration)
        let aniResume = ValueAnimator.animate("resume", from: 0, to: 10, duration: duration)

        aniFinish.endCallback = { finishedExp.fulfill() }
        aniResume.endCallback = { resumedExp.fulfill() }

        aniPause.resume()
        aniFinish.resume()
        aniResume.resume()

        // Pause one mid-flight
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            aniPause.pause()
        }
        // Force-finish another early
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            aniFinish.finish()
        }

        wait(for: [finishedExp, resumedExp], timeout: duration + 1.0)

        // The paused animation should still be paused
        XCTAssertFalse(aniPause.isAnimating)
        XCTAssertFalse(aniPause.isFinished)

        aniPause.dispose()
    }

    // MARK: - Different durations completing in order

    func testDifferentDurationsCompleteInOrder() {
        var finishOrder = [String]()
        let allDone = XCTestExpectation(description: "All 3 animations done")
        allDone.expectedFulfillmentCount = 3

        let fast = ValueAnimator.animate("fast", from: 0, to: 1, duration: 0.3)
        fast.endCallback = {
            finishOrder.append("fast")
            allDone.fulfill()
        }

        let medium = ValueAnimator.animate("medium", from: 0, to: 1, duration: 0.6)
        medium.endCallback = {
            finishOrder.append("medium")
            allDone.fulfill()
        }

        let slow = ValueAnimator.animate("slow", from: 0, to: 1, duration: 0.9)
        slow.endCallback = {
            finishOrder.append("slow")
            allDone.fulfill()
        }

        fast.resume()
        medium.resume()
        slow.resume()

        wait(for: [allDone], timeout: 2.0)

        XCTAssertEqual(finishOrder, ["fast", "medium", "slow"],
                       "Animations should finish in duration order")
    }

    // MARK: - finishAll / disposeAll with concurrent animations

    func testFinishAllWithMultipleAnimations() {
        let count = 5
        let expectations = (0..<count).map {
            XCTestExpectation(description: "Animation \($0) end callback")
        }

        var animators = [ValueAnimator]()
        for i in 0..<count {
            let ani = ValueAnimator.animate(
                "all\(i)", from: 0, to: 10, duration: 2.0
            )
            ani.endCallback = { expectations[i].fulfill() }
            ani.resume()
            animators.append(ani)
        }

        // Give the engine time to start, then finish all at once
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            ValueAnimator.finishAll()
        }

        wait(for: expectations, timeout: 2.0)

        for ani in animators {
            XCTAssertTrue(ani.isFinished)
        }
    }

    func testDisposeAllWithMultipleAnimations() {
        let count = 5
        let noCallbackExp = XCTestExpectation(description: "No end callbacks fired")
        noCallbackExp.isInverted = true // should NOT be fulfilled

        var animators = [ValueAnimator]()
        for i in 0..<count {
            let ani = ValueAnimator.animate(
                "disp\(i)", from: 0, to: 10, duration: 2.0
            )
            ani.endCallback = { noCallbackExp.fulfill() }
            ani.resume()
            animators.append(ani)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            ValueAnimator.disposeAll()
        }

        // Wait a bit — the inverted expectation verifies no callbacks fire
        wait(for: [noCallbackExp], timeout: 1.0)
    }
}
