//
//  AudioFileProperty.swift
//  HALAudio
//
//  Created by Yusuke Ito on 5/2/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import AudioToolbox

public enum AudioFilePropertyError: Error {
    case getPropertyError(prop: AudioFilePropertyID, code: OSStatus)
    case setPropertyError(prop: AudioFilePropertyID, code: OSStatus)
    case noPropertyFound
}

public extension AudioFilePropertyType {
    
    func fileFormat() throws -> AudioFileTypeID {
        return try getProperty(kAudioFilePropertyFileFormat)
    }
    
    func sourceBitDepth() throws -> Int32 {
        return try getProperty(kAudioFilePropertySourceBitDepth)
    }
    
    func estimatedDuration() throws -> Float64 {
        return try getProperty(kAudioFilePropertyEstimatedDuration)
    }
}
