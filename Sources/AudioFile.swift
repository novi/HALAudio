//
//  AudioFile.swift
//  HALAudio
//
//  Created by Yusuke Ito on 5/2/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import AudioToolbox

public protocol AudioFilePropertyType {
    var audioFile: AudioFileID { get }
}

extension AudioFilePropertyType {
    
    func getProperty<T>(prop: AudioFilePropertyID) throws -> T {
        var size = UInt32(sizeof(T))
        var data = unsafeBitCast(calloc(1, Int(size)), UnsafeMutablePointer<T>.self)
        defer {
            free(data)
        }
        let status = AudioFileGetProperty(audioFile, prop, &size, &data)
        guard status == 0 else {
            throw AudioFilePropertyError.GetPropertyError(prop: prop, code: status)
        }
        let result = data.memory
        return result
    }
    
    func setProperty<T>(prop: AudioFilePropertyID, data: T) throws {
        let size = UInt32(sizeof(T))
        var buffer = data
        let status = AudioFileSetProperty(audioFile, prop, size, &buffer)
        guard status == 0 else {
            throw AudioFilePropertyError.SetPropertyError(prop: prop, code: status)
        }
    }
}