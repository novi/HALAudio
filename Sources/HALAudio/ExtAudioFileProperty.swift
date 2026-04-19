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

public enum ExtAudioFilePropertyError: Error {
    case getPropertyError(prop: ExtAudioFilePropertyID, code: OSStatus)
    case setPropertyError(prop: ExtAudioFilePropertyID, code: OSStatus)
    case noPropertyFound
}

public extension ExtAudioFilePropertyType {
    
    func fileDataFormat() throws -> AudioStreamBasicDescription {
        return try getProperty(kExtAudioFileProperty_FileDataFormat)
    }
    
    func audioFile() throws -> AudioFileID {
        return try getProperty(kExtAudioFileProperty_AudioFile)
    }
    
    func fileLengthFrames() throws -> Int64 {
        return try getProperty(kExtAudioFileProperty_FileLengthFrames)
    }
    
    func clientDataFormat(format: AudioStreamBasicDescription) throws {
        try setProperty(data: format, prop: kExtAudioFileProperty_ClientDataFormat)
    }
    
    func converterConfig() throws -> NSDictionary? {
        var result: NSDictionary? = nil
        result = try getProperty(kExtAudioFileProperty_ConverterConfig)
        return result
    }
}
