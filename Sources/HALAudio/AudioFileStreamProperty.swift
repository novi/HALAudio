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

public enum AudioFileStreamPropertyError: Error {
    case getPropertyError(prop: AudioFileStreamPropertyID, code: OSStatus)
    case setPropertyError(prop: AudioFileStreamPropertyID, code: OSStatus)
    case noPropertyFound(prop: AudioFileStreamPropertyID)
}


extension AudioFileStreamPropertyType {
    
    
    public func fileFormat() throws -> UInt32 {
        return try getProperty(kAudioFileStreamProperty_FileFormat)
    }
    
    public func dataFormat() throws -> AudioStreamBasicDescription {
        return try getProperty(kAudioFileStreamProperty_DataFormat)
    }
    
    public func magicCookie() throws -> [UInt8] {
        return try getPropertyArray(kAudioFileStreamProperty_MagicCookieData)
    }
    
    public func audioDataByteCount() throws -> UInt64 {
        return try getProperty(kAudioFileStreamProperty_AudioDataByteCount)
    }
}
