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

import AudioToolbox

public protocol AudioFileStreamPropertyType {
    var audioStream: AudioFileStreamID { get }
    var lock: HALAudioLock { get }
}

public enum AudioFileStreamError: Error {
    case openError(OSStatus)
}

extension AudioFileStreamPropertyType {
    
    func getProperty<T>(_ prop: AudioFileStreamPropertyID) throws -> T {
        let values: [T] = try getPropertyArray(prop)
        guard let val = values.first else {
            throw AudioFileStreamPropertyError.noPropertyFound(prop: prop)
        }
        return val
    }
    func getPropertyArray<T>(_ prop: AudioFileStreamPropertyID) throws -> [T] {
        try lock.withLock { _ in
            var dataSize: UInt32 = 0
            var writable: DarwinBoolean = false
            let sizeStatus = AudioFileStreamGetPropertyInfo(audioStream, prop, &dataSize, &writable)
            guard sizeStatus == 0 else {
                throw AudioFileStreamPropertyError.getPropertyError(prop: prop, code: sizeStatus)
            }

            let data = unsafeBitCast(calloc(1, Int(dataSize)), to: UnsafeMutablePointer<T>.self)
            defer {
                free(data)
            }
            
            let dataStatus = AudioFileStreamGetProperty(audioStream, prop, &dataSize, data)
            guard dataStatus == 0 else {
                throw AudioFileStreamPropertyError.getPropertyError(prop: prop, code: dataStatus)
            }
            
            let count = Int(dataSize / UInt32(MemoryLayout<T>.size))
            
            return (0..<count).map { data[$0] }
        }
    }
    
    func setProperty<T>(data: T, prop: AudioFileStreamPropertyID) throws {
        try lock.withLock { _ in
            let size = UInt32(MemoryLayout<T>.size)
            var buffer = data
            let status = withUnsafePointer(to: &buffer) { ptr in
                AudioFileStreamSetProperty(audioStream, prop, size, ptr)
            }
            guard status == 0 else {
                throw AudioFileStreamPropertyError.setPropertyError(prop: prop, code: status)
            }
        }
    }
}
