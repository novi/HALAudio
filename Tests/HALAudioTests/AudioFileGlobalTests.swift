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

import XCTest
@testable import HALAudio
import AudioToolbox

final class AudioFileGlobalTests: XCTestCase {

    
    func testAllExtensions() throws {
        
        let exts = try AudioFileGlobal.Property.AllExtensions().get() as! [String]
        XCTAssertTrue(exts.contains("m4a"))
        XCTAssertTrue(exts.contains("mp3"))
    }
    
    func testAudioFileTypeName() throws {
        let name = try AudioFileGlobal.Property.FileTypeName(fileTypeID: kAudioFileM4AType).get() as String
        XCTAssertEqual(name, "Apple MPEG-4 Audio")
        
    }
    
    func testAudioFileTypeName_Error() throws {
        do {
            _ = try AudioFileGlobal.Property.FileTypeName(fileTypeID: 99).get() as String
        } catch let error as AudioFileGlobalError {
            switch error {
            case .getPropertyError:
                break // OK
            default:
                XCTFail("not expected error raised \(error)")
            }
        }
    }

}
