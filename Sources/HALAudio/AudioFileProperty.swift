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

public enum AudioFilePropertyError: Error {
    case getPropertyError(prop: AudioFilePropertyID, code: OSStatus)
    case setPropertyError(prop: AudioFilePropertyID, code: OSStatus)
    case noPropertyFound
}

public extension AudioFilePropertyType {
    
    func fileFormat() throws -> AudioFileTypeID {
        return try getProperty(kAudioFilePropertyFileFormat)
    }
    
    func sourceBitDepth() throws -> Int32 {
        return try getProperty(kAudioFilePropertySourceBitDepth)
    }
    
    func estimatedDuration() throws -> Float64 {
        return try getProperty(kAudioFilePropertyEstimatedDuration)
    }
}
