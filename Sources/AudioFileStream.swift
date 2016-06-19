//
//  AudioFileStream.swift
//  HALAudio
//
//  Created by Yusuke Ito on 6/19/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import AudioToolbox

public protocol AudioFileStreamPropertyType {
    var audioStream: AudioFileStreamID { get }
}

extension AudioFileStreamPropertyType {
    
    func getProperty<T>(_ prop: AudioFileStreamPropertyID) throws -> T {
        guard let val: T = try getPropertyArray(prop).first else {
            throw AudioFileStreamPropertyError.noPropertyFound
        }
        return val
    }
    func getPropertyArray<T>(_ prop: AudioFileStreamPropertyID) throws -> [T] {
        
        var dataSize: UInt32 = 0
        var writable: DarwinBoolean = false
        let sizeStatus = AudioFileStreamGetPropertyInfo(audioStream, prop, &dataSize, &writable)
        guard sizeStatus == 0 else {
            throw AudioFileStreamPropertyError.getPropertyError(prop: prop, code: sizeStatus)
        }

        var data = unsafeBitCast(calloc(1, Int(dataSize)), to: UnsafeMutablePointer<T>.self)
        defer {
            free(data)
        }
        
        let dataStatus = AudioFileStreamGetProperty(audioStream, prop, &dataSize, data)
        guard dataStatus == 0 else {
            throw AudioFileStreamPropertyError.getPropertyError(prop: prop, code: dataStatus)
        }
        
        let count = Int(dataSize / UInt32(sizeof(T)))
        
        return (0..<count).map { data[$0] }
    }
    
    func setProperty<T>(data: T, prop: AudioFileStreamPropertyID) throws {
        let size = UInt32(sizeof(T))
        var buffer = data
        let status = AudioFileStreamSetProperty(audioStream, prop, size, &buffer)
        guard status == 0 else {
            throw AudioFileStreamPropertyError.setPropertyError(prop: prop, code: status)
        }
    }
}
