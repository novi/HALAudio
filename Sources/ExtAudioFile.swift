//
//  ExtAudioFile.swift
//  HALAudio
//
//  Created by Yusuke Ito on 5/2/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import AudioToolbox

public protocol ExtAudioFilePropertyType {
    var audioFile: ExtAudioFileRef { get }
}

public protocol ExtAudioFileType {
    var audioFile: ExtAudioFileRef { get }
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
        var size = UInt32(MemoryLayout<T>.size)
        var data = unsafeBitCast(calloc(1, Int(size)), to: UnsafeMutablePointer<T>.self)
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
    
    func setProperty<T>(data: T, prop: ExtAudioFilePropertyID) throws {
        let size = UInt32(MemoryLayout<T>.size)
        var buffer = data
        let status = ExtAudioFileSetProperty(audioFile, prop, size, &buffer)
        guard status == 0 else {
            throw ExtAudioFilePropertyError.setPropertyError(prop: prop, code: status)
        }
    }
}
