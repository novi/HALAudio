import Dispatch
import Foundation
import XCTest
@testable import HALAudio

private final class CriticalSectionState: @unchecked Sendable {
    var activeCount = 0
    var maxActiveCount = 0
}

final class HALAudioLockTests: XCTestCase {
    func testWithLockReturnsValue() {
        let lock = HALAudioLock(())

        let value = lock.withLock { _ in
            "locked"
        }

        XCTAssertEqual(value, "locked")
    }

    func testWithLockUnlocksAfterThrow() {
        enum TestError: Error {
            case expected
        }

        let lock = HALAudioLock(())

        XCTAssertThrowsError(try lock.withLock { _ in
            throw TestError.expected
        }) { error in
            XCTAssertEqual(error as? TestError, .expected)
        }

        let value = lock.withLock { _ in
            42
        }
        XCTAssertEqual(value, 42)
    }

    func testCopiedLocksShareUnderlyingStorage() {
        let lock = HALAudioLock(())
        let copiedLock = lock

        let holderStarted = DispatchSemaphore(value: 0)
        let releaseHolder = DispatchSemaphore(value: 0)
        let secondLockAcquired = DispatchSemaphore(value: 0)

        DispatchQueue.global().async {
            lock.withLock { _ in
                holderStarted.signal()
                releaseHolder.wait()
            }
        }

        XCTAssertEqual(holderStarted.wait(timeout: .now() + 1.0), .success)

        DispatchQueue.global().async {
            _ = copiedLock.withLock { _ in
                secondLockAcquired.signal()
            }
        }

        XCTAssertEqual(secondLockAcquired.wait(timeout: .now() + 0.1), .timedOut)

        releaseHolder.signal()

        XCTAssertEqual(secondLockAcquired.wait(timeout: .now() + 1.0), .success)
    }

    func testConcurrentCriticalSectionIsSerialized() {
        let lock = HALAudioLock(())
        let queue = DispatchQueue(label: "HALAudioLockTests.concurrent", attributes: .concurrent)
        let stateQueue = DispatchQueue(label: "HALAudioLockTests.state")
        let group = DispatchGroup()
        let state = CriticalSectionState()

        for _ in 0..<50 {
            group.enter()
            queue.async {
                lock.withLock { _ in
                    stateQueue.sync {
                        state.activeCount += 1
                        state.maxActiveCount = max(state.maxActiveCount, state.activeCount)
                    }

                    Thread.sleep(forTimeInterval: 0.001)

                    stateQueue.sync {
                        state.activeCount -= 1
                    }
                }
                group.leave()
            }
        }

        XCTAssertEqual(group.wait(timeout: .now() + 5.0), .success)

        stateQueue.sync {
            XCTAssertEqual(state.maxActiveCount, 1)
            XCTAssertEqual(state.activeCount, 0)
        }
    }
}
