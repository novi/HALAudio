//
//  AudioFileGlobalProperty.swift
//  HALAudio
//
//  Created by Yusuke Ito on 10/31/17.
//  Copyright © 2017 Yusuke Ito. All rights reserved.
//

import CoreAudio
import AudioToolbox


public final class AudioFileGlobalProperty {
    
    public struct AllExtensions: AudioFileGlobalPropertyType {
        public let propertyID: AudioFilePropertyID = kAudioFileGlobalInfo_AllExtensions
        public let specifier: UnsafeRawPointer? = nil
        public let specifierSize: Int = 0
        public typealias DataType = CFArray
        
        public init() {
        }
    }
    
    public struct FileTypeName: AudioFileGlobalPropertyType {
        public let propertyID: AudioFilePropertyID = kAudioFileGlobalInfo_FileTypeName
        public let specifier: AudioFileTypeID?
        public let specifierSize: Int = MemoryLayout<AudioFileTypeID>.size
        public typealias DataType = CFString
        
        public init(fileTypeID: AudioFileTypeID) {
            self.specifier = fileTypeID
        }
    }
}
