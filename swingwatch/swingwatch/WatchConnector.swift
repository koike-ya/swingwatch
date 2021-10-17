//
//  WatchConnector.swift
//  swingwatch
//
//  Created by 小池智哉 on 2021/10/16.
//

import Foundation
import WatchConnectivity

protocol WatchConnectorDelegate {
    func didReceiveMessage(message: String)
    func didReceiveFile(url: URL)
}

class WatchConnector: NSObject, WCSessionDelegate {
    
    var delegate: WatchConnectorDelegate?
    
    init(_ delegate: WatchConnectorDelegate? = nil) {
        self.delegate = delegate
        super.init()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        } else {
            print("WCSession is not supported")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        print(#function)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error { print(#function, error) }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("received message: \(message)")
        print(#function)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        self.delegate?.didReceiveMessage(message: message["debug"] as! String? ?? "")
        print("received message: \(message)")
        replyHandler(["debug": "ok"])
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print(#function)
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print(#function)
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dest = url.appendingPathComponent(file.fileURL.lastPathComponent)
        try! FileManager.default.copyItem(at: file.fileURL, to:dest)
        delegate?.didReceiveFile(url: dest)
    }
}
