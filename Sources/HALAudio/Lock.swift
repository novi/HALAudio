import Mutex

public typealias HALAudioLock = Mutex<Void>

extension Mutex where Value == Void {
    @inlinable
    func withLock<R>(_ body: () throws -> R) rethrows -> R {
        try withLock { _ in
            try body()
        }
    }

    @inlinable
    func withLockVoid(_ body: () throws -> Void) rethrows {
        try withLock { _ in
            try body()
        }
    }
}
