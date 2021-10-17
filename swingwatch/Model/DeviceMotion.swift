//
//  MotionSensor.swift
//  swingwatch WatchKit Extension
//
//  Created by 小池智哉 on 2021/10/17.
//
// c.f. https://developer.apple.com/documentation/coremotion/cmdevicemotion
//

import Foundation
import CoreMotion

struct DeviceMotion {
    let datetime: Date
    let motion: CMDeviceMotion
    
    static func parse(datetime: Date, motion: CMDeviceMotion) -> DeviceMotion {
        return DeviceMotion(datetime: datetime, motion: motion)
    }
    
    static func getFieldNames() -> [String] {
        return Array([
            ["datetime"],
            CMDeviceMotion.getFieldNames(),
        ].joined())
    }
    
    func toString() -> String {
        return "\(self.datetime.toYYYYMMddHHmmssZZZZZZString())," + self.motion.getValues().map { String(format: "%f", $0) }.joined(separator: ",")
    }
}

extension CMDeviceMotion {
    func getValues() -> [Double] {
        return Array([
            self.attitude.getValues(),
            self.rotationRate.getValues(),
            self.gravity.getValues(),
            self.userAcceleration.getValues(),
            self.magneticField.field.getValues(),
            [Double(self.magneticField.accuracy.rawValue)]
        ].joined())
    }
    
    static func getFieldNames() -> [String] {
        return Array([
            CMAttitude.getFieldNames().map { "attitude.\($0)" },
            CMRotationRate.getFieldNames().map { "rotationRate.\($0)" },
            CMAcceleration.getFieldNames().map { "gravity.\($0)" },
            CMAcceleration.getFieldNames().map { "userAcceleration.\($0)" },
            CMMagneticField.getFieldNames().map { "magneticField.\($0)" },
            ["magneticFieldCalibrationAccuracy"],
        ].joined())
    }
}

extension CMAcceleration {
    func getValues() -> [Double] {
        return [
            self.x,
            self.y,
            self.z,
        ]
    }
    
    static func getFieldNames() -> [String] {
        return ["x", "y", "z"]
    }
}

extension CMAttitude {
    func getValues() -> [Double] {
        return [
            self.roll,
            self.pitch,
            self.yaw,
        ]
    }
    
    static func getFieldNames() -> [String] {
        return ["roll", "pitch", "yaw"]
    }
}

extension CMRotationRate {
    func getValues() -> [Double] {
        return [
            self.x,
            self.y,
            self.z,
        ]
    }
    
    static func getFieldNames() -> [String] {
        return ["x", "y", "z"]
    }
}

extension CMMagneticField {
    func getValues() -> [Double] {
        return [
            self.x,
            self.y,
            self.z,
        ]
    }
    
    static func getFieldNames() -> [String] {
        return ["x", "y", "z"]
    }
}
