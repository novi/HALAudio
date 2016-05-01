//
//  AudioObject.swift
//  dsdplayer
//
//  Created by Yusuke Ito on 4/13/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import CoreAudio

public protocol AudioObjectPropertyType {
}

extension UInt32: AudioObjectPropertyType {
}

extension CFString: AudioObjectPropertyType {
}

extension Float32: AudioObjectPropertyType {
}

extension AudioStreamBasicDescription: AudioObjectPropertyType {
}

extension AudioStreamRangedDescription: AudioObjectPropertyType {
}

extension pid_t: AudioObjectPropertyType {
}

extension AudioValueRange: AudioObjectPropertyType {
}

public enum AudioObjectError: ErrorType {
    case GetPropertyError(code: OSStatus)
    case SetPropertyError(code: OSStatus)
    case NoPropertyFound
}

public protocol AudioObjectType: CustomStringConvertible {
    var id: AudioObjectID { get }
}

public protocol AudioObjectPropertyAddressType {
    associatedtype PropertyType: AudioObjectPropertyType
    
    var propertyAddress: AudioObjectPropertyAddress { get }
}

public protocol AudioObjectPropertyAddressTypeElementMaster: AudioObjectPropertyAddressType {
    var propertySelector: AudioObjectPropertySelector { get }
    var propertyScope: AudioObjectPropertyScope { get }
}

public extension AudioObjectPropertyAddressTypeElementMaster {
    var propertyAddress: AudioObjectPropertyAddress {
        return AudioObjectPropertyAddress(mSelector: propertySelector,
                                          mScope: propertyScope,
                                          mElement: kAudioObjectPropertyElementMaster)
    }
    
    var propertyScope: AudioObjectPropertyScope {
        return kAudioObjectPropertyScopeGlobal
    }
}

public extension AudioObjectType {
    
    func get<T: AudioObjectPropertyAddressType>(addr: T) throws -> T.PropertyType {
        guard let val: T.PropertyType = try get(addr).first else {
            throw AudioObjectError.NoPropertyFound
        }
        return val
    }
    
    func get<T: AudioObjectPropertyAddressType>(addr: T) throws -> [T.PropertyType] {
        
        var propAddr = addr.propertyAddress
        
        var propSize: UInt32 = 0
        let statusSize = AudioObjectGetPropertyDataSize(id,
                                                        &propAddr,
                                                        0,
                                                        nil,
                                                        &propSize)
        guard statusSize == OSStatus(0) else {
            throw AudioObjectError.GetPropertyError(code: statusSize)
        }
        
        if propSize == 0 {
            return []
        }
        
        let count = Int(propSize / UInt32(sizeof(T.PropertyType.self)))
        
        //print("prop", propAddr.mSelector, propSize, sizeof(T.self), T.self, count)
        
        let memory = unsafeBitCast(calloc(1, Int(propSize)), UnsafeMutablePointer<T.PropertyType>.self)
        
        defer {
            free(memory)
        }
        
        let statusData = AudioObjectGetPropertyData(id,
                                                    &propAddr,
                                                    0,
                                                    nil,
                                                    &propSize,
                                                    memory)
        
        guard statusData == OSStatus(0) else {
            throw AudioObjectError.GetPropertyError(code: statusData)
        }
        
        return (0..<count).map { memory[$0] }
    }
    
    func set<T: AudioObjectPropertyAddressType>(value: T.PropertyType, addr: T) throws {
        try set([value], addr: addr)
    }
    
    func set<T: AudioObjectPropertyAddressType>(values: [T.PropertyType], addr: T) throws {
        
        var propAddr = addr.propertyAddress
        
        let propSize = sizeof(T.PropertyType.self) * values.count
        
        //print(propSize)
        
        let memory = unsafeBitCast(calloc(1, Int(propSize)), UnsafeMutablePointer<T.PropertyType>.self)
        
        // prepare values to set to memory that allocated
        for i in 0..<values.count {
            memory[i] = values[i]
        }
        
        defer {
            free(memory)
        }
        
        let status = AudioObjectSetPropertyData(id,
                                                &propAddr,
                                                0,
                                                nil,
                                                UInt32(propSize),
                                                memory)
        guard status == OSStatus(0) else {
            throw AudioObjectError.SetPropertyError(code: status)
        }
    }
    
    var description: String {
        return "\(id)"
    }
}