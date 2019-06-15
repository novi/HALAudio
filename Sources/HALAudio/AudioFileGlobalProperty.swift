//
//  AudioFileGlobalProperty.swift
//  HALAudio
//
//  Created by Yusuke Ito on 10/31/17.
//  Copyright © 2017 Yusuke Ito. All rights reserved.
//

import CoreAudio
import AudioToolbox


public struct AudioFileGlobal {
    
    public struct Property {
        
        public struct AllExtensions: AudioFileGlobalProperty {
            public let propertyID: AudioFilePropertyID = kAudioFileGlobalInfo_AllExtensions
            public let specifier: UnsafeRawPointer? = nil
            public let specifierSize: Int = 0
            //public typealias DataType = [String]
            public typealias RawDataType = CFArray
            
            public init() {
            }
        }
        
        public struct FileTypeName: AudioFileGlobalProperty {
            public let propertyID: AudioFilePropertyID = kAudioFileGlobalInfo_FileTypeName
            public let specifier: AudioFileTypeID?
            public let specifierSize: Int = MemoryLayout<AudioFileTypeID>.size
            //public typealias DataType = String
            public typealias RawDataType = CFString
            
            public init(fileTypeID: AudioFileTypeID) {
                self.specifier = fileTypeID
            }
        }
        
    }
    
    
}
