//
//  ExtAudioFileProperty.swift
//  HALAudio
//
//  Created by Yusuke Ito on 5/2/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import AudioToolbox

public enum ExtAudioFilePropertyError: ErrorProtocol {
    case getPropertyError(prop: ExtAudioFilePropertyID, code: OSStatus)
    case setPropertyError(prop: ExtAudioFilePropertyID, code: OSStatus)
    case noPropertyFound
}

public extension ExtAudioFilePropertyType {
    
    func fileDataFormat() throws -> AudioStreamBasicDescription {
        return try getProperty(kExtAudioFileProperty_FileDataFormat)
    }
    
    func audioFile() throws -> AudioFileID {
        return try getProperty(kExtAudioFileProperty_AudioFile)
    }
    
    func fileLengthFrames() throws -> Int64 {
        return try getProperty(kExtAudioFileProperty_FileLengthFrames)
    }
    
    func clientDataFormat(format: AudioStreamBasicDescription) throws {
        try setProperty(data: format, prop: kExtAudioFileProperty_ClientDataFormat)
    }
    
    func converterConfig() throws -> NSDictionary? {
        var result: NSDictionary? = nil
        result = try getProperty(kExtAudioFileProperty_ConverterConfig)
        return result
    }
}
