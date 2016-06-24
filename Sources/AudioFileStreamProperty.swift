//
//  AudioFileStreamProperty.swift
//  HALAudio
//
//  Created by Yusuke Ito on 6/19/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import AudioToolbox

public enum AudioFileStreamPropertyError: ErrorProtocol {
    case getPropertyError(prop: AudioFileStreamPropertyID, code: OSStatus)
    case setPropertyError(prop: AudioFileStreamPropertyID, code: OSStatus)
    case noPropertyFound(prop: AudioFileStreamPropertyID)
}


extension AudioFileStreamPropertyType {
    
    
    public func fileFormat() throws -> UInt32 {
        return try getProperty(kAudioFileStreamProperty_FileFormat)
    }
    
    public func dataFormat() throws -> AudioStreamBasicDescription {
        return try getProperty(kAudioFileStreamProperty_DataFormat)
    }
    
    public func magicCookie() throws -> [UInt8] {
        return try getPropertyArray(kAudioFileStreamProperty_MagicCookieData)
    }
    
    public func audioDataByteCount() throws -> UInt64 {
        return try getProperty(kAudioFileStreamProperty_AudioDataByteCount)
    }
}
