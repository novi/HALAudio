//
//  AudioConverterProperty.swift
//  HALAudio
//
//  Created by Yusuke Ito on 6/22/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import AudioToolbox


public enum AudioConverterPropertyError: Error {
    case getPropertyError(prop: AudioConverterPropertyID, code: OSStatus)
    case setPropertyError(prop: AudioConverterPropertyID, code: OSStatus)
    case noPropertyFound(prop: AudioConverterPropertyID)
}


extension AudioConverterPropertyType {
    
    
    public func decompressionMagicCookie(_ bytes: [UInt8]) throws {
        try setProperty(bytes: bytes, prop: kAudioConverterDecompressionMagicCookie)
    }
    
    public func maximumOutputPacketSize() throws -> UInt32 {
        return try getProperty(kAudioConverterPropertyMaximumOutputPacketSize)
    }
}
