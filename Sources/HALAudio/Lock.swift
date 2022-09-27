//
//  Lock.swift
//  
//
//  Created by Yusuke Ito on 9/27/22.
//

import Foundation


public final class UnfairLock {
    private let lock: UnsafeMutablePointer<os_unfair_lock>
    public init() {
        lock = .allocate(capacity: 1)
        lock.initialize(to: .init())
    }
    
    deinit {
        lock.deinitialize(count: 1)
        lock.deallocate()
    }
    
    public func sync<T>(_ block: () throws -> T) rethrows -> T {
        os_unfair_lock_lock(lock)
        defer {
            os_unfair_lock_unlock(lock)
        }
        return try block()
    }
}
