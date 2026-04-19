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
