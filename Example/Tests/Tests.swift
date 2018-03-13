// https://github.com/Quick/Quick

import Quick
import Nimble
import ValueAnimator

class ValueAnimatorSpec: QuickSpec {
    
    var count: Double = 0.0
    
    override func spec() {
        describe("animator") {
            
            it("can do maths") {
                expect(23) == 23
            }
            
//
//            it("is not animating") {
//                expect(ani.isAnimating).to(beFalsy())
//            }
//            ani.resume()
//            it("is animating") {
//                expect(ani.isAnimating).to(beTruthy())
//            }

            //            it("is finished in correct value") {
//                waitUntil { done in
//                    Thread.sleep(forTimeInterval: 1.1)
//                    expect(self.count) == Double(10)
//                    done()
//                }
//            }
//
//            context("these will pass") {
//
//                it("can do maths") {
//                    expect(23) == 23
//                }
//
//                it("can read") {
//                    expect("🐮") == "🐮"
//                }
//
//                it("will eventually pass") {
//                    var time = "passing"
//
//                    DispatchQueue.main.async {
//                        time = "done"
//                    }
//
//                    waitUntil { done in
//                        Thread.sleep(forTimeInterval: 0.5)
//                        expect(time) == "done"
//
//                        done()
//                    }
//                }
//            }
        }
    }
}
