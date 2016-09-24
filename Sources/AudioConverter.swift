//
//  AudioConverter.swift
//  HALAudio
//
//  Created by Yusuke Ito on 6/22/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import AudioToolbox

public protocol AudioConverterType {
    var converter: AudioConverterRef { get }
}

public enum AudioConverterError: Error {
    case createError(OSStatus)
}

public protocol AudioConverterPropertyType {
    var converter: AudioConverterRef { get }
}


extension AudioConverterPropertyType {
    
    func getProperty<T>(_ prop: AudioConverterPropertyID) throws -> T {
        guard let val: T = try getPropertyArray(prop).first else {
            throw AudioConverterPropertyError.noPropertyFound(prop: prop)
        }
        return val
    }
    func getPropertyArray<T>(_ prop: AudioConverterPropertyID) throws -> [T] {
        
        var dataSize: UInt32 = 0
        var writable: DarwinBoolean = false
        let sizeStatus = AudioConverterGetPropertyInfo(converter, prop, &dataSize, &writable)
        guard sizeStatus == 0 else {
            throw AudioConverterPropertyError.getPropertyError(prop: prop, code: sizeStatus)
        }
        
        var data = unsafeBitCast(calloc(1, Int(dataSize)), to: UnsafeMutablePointer<T>.self)
        defer {
            free(data)
        }
        
        let dataStatus = AudioConverterGetProperty(converter, prop, &dataSize, data)
        guard dataStatus == 0 else {
            throw AudioConverterPropertyError.getPropertyError(prop: prop, code: dataStatus)
        }
        
        let count = Int(dataSize / UInt32(MemoryLayout<T>.size))
        
        return (0..<count).map { data[$0] }
    }
    
    func setProperty<T>(data: T, prop: AudioConverterPropertyID) throws {
        let size = UInt32(MemoryLayout<T>.size)
        var buffer = data
        let status = AudioConverterSetProperty(converter, prop, size, &buffer)
        guard status == 0 else {
            throw AudioConverterPropertyError.setPropertyError(prop: prop, code: status)
        }
    }
    
    func setProperty(bytes: [UInt8], prop: AudioConverterPropertyID) throws {
        var buffer = bytes
        let status = AudioConverterSetProperty(converter, prop, UInt32(bytes.count), &buffer)
        guard status == 0 else {
            throw AudioConverterPropertyError.setPropertyError(prop: prop, code: status)
        }
    }
}


