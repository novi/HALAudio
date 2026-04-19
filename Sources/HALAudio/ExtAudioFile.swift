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

public protocol ExtAudioFilePropertyType {
    var audioFile: ExtAudioFileRef { get }
    var lock: HALAudioLock { get }
}

public protocol ExtAudioFileType {
    var audioFile: ExtAudioFileRef { get }
    // TODO: locking
}

public enum ExtAudioFileError: Error {
    case urlOpenError(NSURL, OSStatus)
    case readError(OSStatus)
    case seekError(OSStatus)
}

public extension ExtAudioFileType {
    
    static func open(fromURL url: NSURL) throws -> ExtAudioFileRef {
        var ptr: ExtAudioFileRef? = nil
        let status = ExtAudioFileOpenURL(url as CFURL, &ptr)
        guard let newPtr = ptr, status == 0 else {
            throw ExtAudioFileError.urlOpenError(url, status)
        }
        return newPtr
    }
    
    static func dispose(ptr: ExtAudioFileRef) {
        ExtAudioFileDispose(ptr)
    }
    
    func read(frames: UInt32, buffer: UnsafeMutablePointer<AudioBufferList>) throws -> UInt32 {
        var readFrames = frames
        let status = ExtAudioFileRead(audioFile, &readFrames, buffer)
        guard status == 0 else {
            throw ExtAudioFileError.readError(status)
        }
        return readFrames
    }
    
    func seek(offset: Int64) throws {
        let status = ExtAudioFileSeek(audioFile, offset)
        guard status == 0 else {
            throw ExtAudioFileError.seekError(status)
        }
    }
    
}

public extension ExtAudioFilePropertyType {
    func getProperty<T>(_ prop: ExtAudioFilePropertyID) throws -> T {
        try lock.withLock { _ in
            var size = UInt32(MemoryLayout<T>.size)
            let data = unsafeBitCast(calloc(1, Int(size)), to: UnsafeMutablePointer<T>.self)
            defer {
                free(data)
            }
            let status = ExtAudioFileGetProperty(audioFile, prop, &size, data)
            guard status == 0 else {
                throw ExtAudioFilePropertyError.getPropertyError(prop: prop, code: status)
            }
            let result = data[0]
            return result
        }
    }
    
    func setProperty<T>(data: T, prop: ExtAudioFilePropertyID) throws {
        try lock.withLock { _ in
            let size = UInt32(MemoryLayout<T>.size)
            var buffer = data
            let status = withUnsafePointer(to: &buffer) { ptr in
                ExtAudioFileSetProperty(audioFile, prop, size, ptr)
            }
            guard status == 0 else {
                throw ExtAudioFilePropertyError.setPropertyError(prop: prop, code: status)
            }
        }
    }
}
