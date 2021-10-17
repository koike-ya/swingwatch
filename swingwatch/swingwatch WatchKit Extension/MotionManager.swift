//
//  MotionManager.swift
//  swingwatch WatchKit Extension
//
//  Created by 小池智哉 on 2021/10/17.
//

import Foundation
import CoreMotion

protocol MotionManagerDelegate {
    func didReceivedMotionData(_ motion: DeviceMotion)
    func didStop(_ motions: [DeviceMotion])
}

class MotionManager: NSObject {
    private let motionManager = CMMotionManager()
    private var delegate: MotionManagerDelegate?
    private var motions: [DeviceMotion] = []
    
    init(delegate: MotionManagerDelegate? = nil) {
        self.delegate = delegate
    }
    
    func start() {
        if motionManager.isDeviceMotionAvailable {
            // If your app is sensitive to the intervals of device-motion data, it should always check the timestamps of the delivered CMDeviceMotion instances to determine the true update interval
            motionManager.deviceMotionUpdateInterval = 0.005
            motionManager.startDeviceMotionUpdates(using: [.xMagneticNorthZVertical], to: OperationQueue.current!) { motion, error in
                self.updateMotionData(deviceMotion: motion!)
            }
        }
    }
    
    func updateMotionData(deviceMotion: CMDeviceMotion) {
        let motion = DeviceMotion(datetime: Date(), motion: deviceMotion)
        delegate?.didReceivedMotionData(motion)
        motions.append(motion)
    }
    
    func stop() {
        motionManager.stopDeviceMotionUpdates()
        delegate?.didStop(motions)
    }
    
    func isDuringMeasurement() -> Bool {
        return motionManager.isDeviceMotionActive
    }
}
