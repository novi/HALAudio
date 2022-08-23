//
//  AudioFileGlobalTests.swift
//  HALAudioTests
//
//  Created by Yusuke Ito on 10/31/17.
//  Copyright © 2017 Yusuke Ito. All rights reserved.
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
