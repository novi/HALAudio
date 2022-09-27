//
//  AudioFileGlobal.swift
//  HALAudio
//
//  Created by Yusuke Ito on 10/31/17.
//  Copyright © 2017 Yusuke Ito. All rights reserved.
//

import AudioToolbox

@globalActor
public struct AudioFileGlobalActor {
  public actor Actor {}
  public static let shared = Actor()
}

public protocol AudioFileGlobalProperty {
    //associatedtype DataType
    associatedtype RawDataType
    associatedtype SpecifierType
    @AudioFileGlobalActor var propertyID: AudioFilePropertyID { get }
    @AudioFileGlobalActor var specifier: SpecifierType? { get }
    @AudioFileGlobalActor var specifierSize: Int { get }
    
    @AudioFileGlobalActor func get() throws -> Self.RawDataType
}

public enum AudioFileGlobalError: Error {
    case getPropertyNoData
    case getPropertyError(code: OSStatus)
    //case propertyDataCastError(data: Any, toType: Any)
}

@AudioFileGlobalActor
extension AudioFileGlobalProperty {

    public func get() throws -> Self.RawDataType {
        
        var outDataSize: UInt32 = 0
        var specifierIn = specifier
        let statusSize = AudioFileGetGlobalInfoSize(propertyID,
                                                    UInt32(specifierSize),
                                                    &specifierIn,
                                                    &outDataSize)
        guard statusSize == OSStatus(0) else {
            throw AudioFileGlobalError.getPropertyError(code: statusSize)
        }
        
        if outDataSize == 0 {
            throw AudioFileGlobalError.getPropertyNoData
        }
        
        let memory = unsafeBitCast(calloc(1, Int(outDataSize)), to: UnsafeMutablePointer<Self.RawDataType>.self)
        
        defer {
            free(memory)
        }
        
        let statusData = AudioFileGetGlobalInfo(propertyID,
                                                UInt32(specifierSize),
                                                &specifierIn,
                                                &outDataSize,
                                                memory)
        
        guard statusData == OSStatus(0) else {
            throw AudioFileGlobalError.getPropertyError(code: statusData)
        }
        
        /*guard let data = memory.pointee as? Self.DataType else {
            throw AudioFileGlobalError.propertyDataCastError(data: memory.pointee, toType: Self.DataType.self)
        }*/
        return memory.pointee
    }

}
