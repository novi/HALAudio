//
//  AudioFileProperty.swift
//  HALAudio
//
//  Created by Yusuke Ito on 5/2/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import AudioToolbox

public enum AudioFilePropertyError: ErrorType {
    case GetPropertyError(prop: AudioFilePropertyID, code: OSStatus)
    case SetPropertyError(prop: AudioFilePropertyID, code: OSStatus)
    case NoPropertyFound
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