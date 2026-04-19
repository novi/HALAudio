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

public protocol AudioFilePropertyType {
    var audioFile: AudioFileID { get }
    var lock: HALAudioLock { get }
}

extension AudioFilePropertyType {
    
    func getProperty<T>(_ prop: AudioFilePropertyID) throws -> T {
        try lock.withLock { _ in
            var size = UInt32(MemoryLayout<T>.size)
            let data = unsafeBitCast(calloc(1, Int(size)), to: UnsafeMutablePointer<T>.self)
            defer {
                free(data)
            }
            let status = AudioFileGetProperty(audioFile, prop, &size, data)
            guard status == 0 else {
                throw AudioFilePropertyError.getPropertyError(prop: prop, code: status)
            }
            let result = data[0]
            return result
        }
    }
    
    func setProperty<T>(data: T, prop: AudioFilePropertyID) throws {
        try lock.withLock { _ in
            let size = UInt32(MemoryLayout<T>.size)
            var buffer = data
            let status = withUnsafePointer(to: &buffer) { ptr in
                AudioFileSetProperty(audioFile, prop, size, ptr)
            }
            guard status == 0 else {
                throw AudioFilePropertyError.setPropertyError(prop: prop, code: status)
            }
        }
    }
}
