//
//  BatteryLevelHelper.swift
//  Battery Level
//
//  Created by Joss Manger on 5/29/17.
//  Copyright © 2017 Joss Manger. All rights reserved.
//
import UIKit
import WatchKit
import WatchConnectivity

enum statusEnum {
    case unknown
    case unplugged
    case charging
    case full
}

@objc protocol BatteryLevelHelperDelegate{
    func dataReady();
}

class BatteryLevelHelper : NSObject {
    
    var session:WCSession!
    var ready:NSNumber!
    var levelFloat:NSNumber!
    var status:NSNumber!
    var date:NSDate!
    var delegate:BatteryLevelHelperDelegate?
    override init(){
        super.init()
        ready = NSNumber.init(booleanLiteral: false);
        print(ready)
        
        session = WCSession.default()
        
    }
    
    func sendRequestMessage(){
        
        //let requestDict:[String:Any] = ["request":"currentBatteryLevelandStatus"];
        let requestDict:[String:Any] = ["request":"dummyBatteryLevelandStatus"];
        session.sendMessage(requestDict, replyHandler: {
            (answer: [String : Any]) in
            print("hello world success \(answer)")
            self.setInstanceVariables(message: answer)
        }, errorHandler: {(_: Error) in
            print("hello world error")
    })
    }
    
    func setInstanceVariables(message:[String : Any]){
        date = message["currentDate"] as! NSDate;
        status = message["batteryStatus"] as! NSNumber;
        levelFloat = message["currentLevelFloat"] as! NSNumber;
        ready = NSNumber.init(booleanLiteral: true);
        print(ready)
        print(date,status,levelFloat)
        delegate?.dataReady()
    }
    
    private func error(message:Error){
        print("error: \(message)")
    }
    
}
