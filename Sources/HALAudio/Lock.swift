import os

public struct HALAudioLock: @unchecked Sendable {
    private let storage: Storage

    public init(_ initialState: Void = ()) {
        storage = Storage(initialState)
    }

    public func withLock<R>(_ body: (inout Void) throws -> R) rethrows -> R {
        storage.lock()
        defer { storage.unlock() }
        return try body(&storage.state)
    }
}

private final class Storage: @unchecked Sendable {
    private let rawLock: os_unfair_lock_t
    var state: Void

    init(_ initialState: Void) {
        rawLock = .allocate(capacity: 1)
        rawLock.initialize(to: os_unfair_lock())
        state = initialState
    }

    func lock() {
        os_unfair_lock_lock(rawLock)
    }

    func unlock() {
        os_unfair_lock_unlock(rawLock)
    }

    deinit {
        rawLock.deinitialize(count: 1)
        rawLock.deallocate()
    }
}
