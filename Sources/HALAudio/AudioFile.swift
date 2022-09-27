//
//  AudioFile.swift
//  HALAudio
//
//  Created by Yusuke Ito on 5/2/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import AudioToolbox

@globalActor
public struct AudioFilePropertyActor {
  public actor Actor {}
  public static let shared = Actor()
}

public protocol AudioFilePropertyType {
    @AudioFilePropertyActor var audioFile: AudioFileID { get }
}

@AudioFilePropertyActor
extension AudioFilePropertyType {
    
    func getProperty<T>(_ prop: AudioFilePropertyID) throws -> T {
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
    
    func setProperty<T>(data: T, prop: AudioFilePropertyID) throws {
        let size = UInt32(MemoryLayout<T>.size)
        var buffer = data
        let status = AudioFileSetProperty(audioFile, prop, size, &buffer)
        guard status == 0 else {
            throw AudioFilePropertyError.setPropertyError(prop: prop, code: status)
        }
    }
}
