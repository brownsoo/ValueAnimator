// https://github.com/Quick/Quick

import Quick
import Nimble
import ValueAnimator


class ValueAnimatorSpec: QuickSpec {
    override func spec() {
        describe("animator spec") {
            describe("its end value") {
                
                var count: Double!
                var ani: ValueAnimator!
                beforeEach {
                    count = Double(0)
                    ani = ValueAnimator.of("count", from: 0, to: 10, duration: 1) { prop, value in
                        print(prop, value)
                        count = value
                    }
                }
                context("isAnimating value") {
                    it("is not animating") {
                        expect(ani.isAnimating).to(beFalsy())
                    }
                    it("is animating") {
                        ani.resume()
                        expect(ani.isAnimating).to(beTruthy())
                    }
                }
                
//
//                waitUntil { done in
//                    Thread.sleep(forTimeInterval: 1.1)
//                    expect(count) == 10
//                    done()
//                }
            }
            
            
            
        }
    }
}

