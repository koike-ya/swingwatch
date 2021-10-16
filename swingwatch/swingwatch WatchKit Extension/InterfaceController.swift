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
    
    override func awake(withContext context: Any?) {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        } else {
            print("WCSession not supported")
        }
    }
    
    override func willActivate() {
        sendMessage("willActivate")
        print(#function)
    }
    
    override func didDeactivate() {
        sendMessage("didDeactivate")
        print(#function)
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
}
