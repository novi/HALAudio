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

public enum ExtAudioFileError: ErrorType {
    case urlOpenError(NSURL, OSStatus)
    case readError(OSStatus)
    case seekError(OSStatus)
}

public extension ExtAudioFileType {
    
    static func open(fromURL url: NSURL) throws -> ExtAudioFileRef {
        var ptr: ExtAudioFileRef = nil
        let status = ExtAudioFileOpenURL(url as CFURL, &ptr)
        guard status == 0 && ptr != nil else {
            throw ExtAudioFileError.urlOpenError(url, status)
        }
        return ptr
    }
    
    static func dispose(ptr: ExtAudioFileRef) {
        ExtAudioFileDispose(ptr)
    }
    
    func read(frames frames: UInt32, buffer: UnsafeMutablePointer<AudioBufferList>) throws -> UInt32 {
        var readFrames = frames
        let status = ExtAudioFileRead(audioFile, &readFrames, buffer)
        guard status == 0 else {
            throw ExtAudioFileError.readError(status)
        }
        return readFrames
    }
    
    func seek(offset offset: Int64) throws {
        let status = ExtAudioFileSeek(audioFile, offset)
        guard status == 0 else {
            throw ExtAudioFileError.seekError(status)
        }
    }
    
}

public extension ExtAudioFilePropertyType {
    func getProperty<T>(prop: ExtAudioFilePropertyID) throws -> T {
        var size = UInt32(sizeof(T))
        var data = unsafeBitCast(calloc(1, Int(size)), UnsafeMutablePointer<T>.self)
        defer {
            free(data)
        }
        let status = ExtAudioFileGetProperty(audioFile, prop, &size, data)
        guard status == 0 else {
            throw ExtAudioFilePropertyError.GetPropertyError(prop: prop, code: status)
        }
        let result = data[0]
        return result
    }
    
    func setProperty<T>(prop: ExtAudioFilePropertyID, data: T) throws {
        let size = UInt32(sizeof(T))
        var buffer = data
        let status = ExtAudioFileSetProperty(audioFile, prop, size, &buffer)
        guard status == 0 else {
            throw ExtAudioFilePropertyError.SetPropertyError(prop: prop, code: status)
        }
    }
}