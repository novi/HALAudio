# HALAudio
CoreAudio Hardware wrapper for Swift

```swift
// Define your AudioDevice type

struct AudioSytemObject: AudioObjectType {
    let id: AudioStreamID
    init() {
        self.id = AudioObjectID(kAudioObjectSystemObject)
    }
}

final class AudioDevice: AudioObjectType {
    let id: AudioDeviceID
    init( _ id: AudioDeviceID) {
        self.id = id
    }
}


// Get all of your devices
let devices:[AudioDevice] = ( try AudioSytemObject().get( AudioHardwareProperty.Devices() ) ).map(AudioDevice.init)

// Get a device name
let name: CFString = try devices[1].get( AudioDeviceProperty.DeviceName() )

name // == "Built-in Output"

```