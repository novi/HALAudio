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

import CoreAudio

public enum AudioHardwareProperty {
    public struct Devices: AudioObjectPropertyAddressTypeElementMaster {
        public typealias DataType = AudioDeviceID
        public var propertySelector: AudioObjectPropertySelector {
            return kAudioHardwarePropertyDevices
        }
        public init() {
        }
    }
}

public enum AudioDeviceProperty {
    
    public enum Direction {
        case Input
        case Output
    }
    
    public struct DeviceName: AudioObjectPropertyAddressTypeElementMaster {
        public typealias DataType = CFString
        public var propertySelector: AudioObjectPropertySelector {
            return kAudioDevicePropertyDeviceNameCFString
        }
        public init() {
        }
    }
    
    public struct DeviceUID: AudioObjectPropertyAddressTypeElementMaster {
        public typealias DataType = CFString
        public var propertySelector: AudioObjectPropertySelector {
            return kAudioDevicePropertyDeviceUID
        }
        public init() {
        }
    }
    
    public struct VolumeScalar: AudioObjectPropertyAddressTypeElementMaster {
        public typealias DataType = Float32
        public var propertySelector: AudioObjectPropertySelector {
            return kAudioDevicePropertyVolumeScalar
        }
        public init() {
        }
    }
    
    public struct Streams: AudioObjectPropertyAddressType {
        public typealias DataType = AudioStreamID
        public let scope: AudioObjectPropertyScope
        public var propertyAddress: AudioObjectPropertyAddress {
            return AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyStreams,
                                              mScope: scope,
                                              mElement: kAudioObjectPropertyElementMaster)
        }
        public init(_ direction: Direction? = nil) {
            if let direction = direction {
                scope = direction == .Input ? kAudioObjectPropertyScopeInput : kAudioObjectPropertyScopeOutput
            } else {
                scope = kAudioObjectPropertyScopeGlobal
            }
        }
    }
    
    public struct HogMode: AudioObjectPropertyAddressTypeElementMaster {
        public typealias DataType = pid_t
        public var propertySelector: AudioObjectPropertySelector {
            return kAudioDevicePropertyHogMode
        }
        public init() {
        }
    }
    
    public struct BufferFrameSizeRange: AudioObjectPropertyAddressTypeElementMaster {
        public typealias DataType = AudioValueRange
        public var propertySelector: AudioObjectPropertySelector {
            return kAudioDevicePropertyBufferFrameSizeRange
        }
        public init() {
        }
    }
    
    public struct BufferFrameSize: AudioObjectPropertyAddressTypeElementMaster {
        public typealias DataType = UInt32
        public var propertySelector: AudioObjectPropertySelector {
            return kAudioDevicePropertyBufferFrameSize
        }
        public init() {
        }
    }
}

public enum AudioStreamProperty {
    
    public struct PhysicalFormat: AudioObjectPropertyAddressTypeElementMaster {
        public typealias DataType = AudioStreamBasicDescription
        public var propertySelector: AudioObjectPropertySelector {
            return kAudioStreamPropertyPhysicalFormat
        }
        public init() {
        }
    }
    
    public struct VirtualFormat: AudioObjectPropertyAddressTypeElementMaster {
        public typealias DataType = AudioStreamBasicDescription
        public var propertySelector: AudioObjectPropertySelector {
            return kAudioStreamPropertyVirtualFormat
        }
        public init() {
        }
    }
    
    public struct AvailablePhysicalFormats: AudioObjectPropertyAddressTypeElementMaster {
        public typealias DataType = AudioStreamRangedDescription
        public var propertySelector: AudioObjectPropertySelector {
            return kAudioStreamPropertyAvailablePhysicalFormats
        }
        public init() {
        }
    }
    
    public struct AvailableVirtualFormats: AudioObjectPropertyAddressTypeElementMaster {
        public typealias DataType = AudioStreamRangedDescription
        public var propertySelector: AudioObjectPropertySelector {
            return kAudioStreamPropertyAvailableVirtualFormats
        }
        public init() {
        }
    }
    
    public struct Latency: AudioObjectPropertyAddressTypeElementMaster {
        public typealias DataType = UInt32
        public var propertySelector: AudioObjectPropertySelector {
            return kAudioStreamPropertyLatency
        }
        public init() {
        }
    }
}

