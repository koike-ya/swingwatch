//
//  InterfaceController.swift
//  swingwatch WatchKit Extension
//
//  Created by 小池智哉 on 2021/10/16.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    var motionManager: MotionManager?
    var writer: CSVWriter?
    
    @IBOutlet weak var changeMeasurementButton: WKInterfaceButton!
    
    @IBAction func didTapChangeMeasurementButton() {
        guard let motionManager = self.motionManager else { return }
        if motionManager.isDuringMeasurement() {
            self.stopMeasurement()
            DispatchQueue.main.async {
                self.changeMeasurementButton.setTitle("Start")
            }
        } else {
            self.startMeasurement()
            DispatchQueue.main.async {
                self.changeMeasurementButton.setTitle("Stop")
            }
        }
    }
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        } else {
            print("WCSession not supported")
        }
        
        writer = CSVWriter()
        motionManager = MotionManager(delegate: self)
    }
    
    override func awake(withContext context: Any?) {
    }
    
    override func willActivate() {
        sendMessage("willActivate")
        print(#function)
    }
    
    override func didDeactivate() {
        sendMessage("didDeactivate")
        print(#function)
    }
    
    func startMeasurement() {
        let fileName = CSVWriter.makeFilePath(Date().toYYYYMMddHHmmssNoDelimiterString())
        let header = DeviceMotion.getFieldNames().joined(separator: ",")
        writer?.open(fileName, header: header)
        motionManager?.start()
        sendMessage("measurement started")
    }
    
    func stopMeasurement() {
        motionManager?.stop()
        guard let url = writer?.close() else { return }
        self.sendFile(url)
        sendMessage("measurement stopped")
    }
}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error { print(#function, error) }
        sendMessage("watch activated")
    }
    
    func sendMessage(_ message: String) {
        DispatchQueue.main.async {
            WCSession.default.sendMessage(["debug": message], replyHandler: { reply in
                print(reply)
            } ) { error in
                print("error", error.localizedDescription)
            }
        }
    }
    
    func sendFile(_ url: URL) {
        WCSession.default.transferFile(url, metadata: nil)
    }
}

extension InterfaceController: MotionManagerDelegate {
    func didReceivedMotionData(_ motion: DeviceMotion) {}
    
    func didStop(_ motions: [DeviceMotion]) {
        writer?.write(motions.map { $0.toString() })
    }
}
