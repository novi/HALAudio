//
//  AudioFileGlobal.swift
//  HALAudio
//
//  Created by Yusuke Ito on 10/31/17.
//  Copyright © 2017 Yusuke Ito. All rights reserved.
//

import AudioToolbox

public protocol AudioFileGlobalPropertyType {
    associatedtype DataType
    associatedtype SpecifierType
    var propertyID: AudioFilePropertyID { get }
    var specifier: SpecifierType? { get }
    var specifierSize: Int { get }
}

public enum AudioFileGlobalError: Error {
    case getPropertyNoDataError
    case getPropertyError(code: OSStatus)
}

public final class AudioFileGlobal {

    public static func get<T: AudioFileGlobalPropertyType>(_ prop: T) throws -> T.DataType {
        
        var outDataSize: UInt32 = 0
        var specifierIn = prop.specifier
        let statusSize = AudioFileGetGlobalInfoSize(prop.propertyID,
                                                    UInt32(prop.specifierSize),
                                                    &specifierIn,
                                                    &outDataSize)
        guard statusSize == OSStatus(0) else {
            throw AudioFileGlobalError.getPropertyError(code: statusSize)
        }
        
        if outDataSize == 0 {
            throw AudioFileGlobalError.getPropertyNoDataError
        }
        
        let memory = unsafeBitCast(calloc(1, Int(outDataSize)), to: UnsafeMutablePointer<T.DataType>.self)
        
        defer {
            free(memory)
        }
        
        let statusData = AudioFileGetGlobalInfo(prop.propertyID,
                                                UInt32(prop.specifierSize),
                                                &specifierIn,
                                                &outDataSize,
                                                memory)
        
        guard statusData == OSStatus(0) else {
            throw AudioFileGlobalError.getPropertyError(code: statusData)
        }
        
        return memory.pointee
    }

}
