//
//  Copyright © 2026 Yusuke Ito. All rights reserved.
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

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
