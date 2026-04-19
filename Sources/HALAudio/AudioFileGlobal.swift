//
//  Copyright © 2026 Yusuke Ito. All rights reserved.
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import AudioToolbox

public protocol AudioFileGlobalProperty {
    //associatedtype DataType
    associatedtype RawDataType
    associatedtype SpecifierType
    var propertyID: AudioFilePropertyID { get }
    var specifier: SpecifierType? { get }
    var specifierSize: Int { get }
    
    func get() throws -> Self.RawDataType
}

public enum AudioFileGlobalError: Error {
    case getPropertyNoData
    case getPropertyError(code: OSStatus)
    //case propertyDataCastError(data: Any, toType: Any)
}

internal let HALAudioGlobalLock = HALAudioLock(())

extension AudioFileGlobalProperty {

    public func get() throws -> Self.RawDataType {
        try HALAudioGlobalLock.withLock { _ in
            var outDataSize: UInt32 = 0
            let statusSize: OSStatus = withSpecifierPointer {
                AudioFileGetGlobalInfoSize(propertyID,
                                           UInt32(specifierSize),
                                           $0,
                                           &outDataSize)
            }
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
            
            let statusData: OSStatus = withSpecifierPointer {
                AudioFileGetGlobalInfo(propertyID,
                                       UInt32(specifierSize),
                                       $0,
                                       &outDataSize,
                                       memory)
            }
            
            guard statusData == OSStatus(0) else {
                throw AudioFileGlobalError.getPropertyError(code: statusData)
            }
            
            /*guard let data = memory.pointee as? Self.DataType else {
                throw AudioFileGlobalError.propertyDataCastError(data: memory.pointee, toType: Self.DataType.self)
            }*/
            return memory.pointee
        }
    }

    private func withSpecifierPointer<T>(_ body: (UnsafeMutableRawPointer?) -> T) -> T {
        guard specifierSize > 0, var specifierValue = specifier else {
            return body(nil)
        }
        return withUnsafeMutablePointer(to: &specifierValue) { pointer in
            body(pointer)
        }
    }

}
