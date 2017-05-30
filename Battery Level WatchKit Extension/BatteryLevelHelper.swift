//
//  BatteryLevelHelper.swift
//  Battery Level
//
//  Created by Joss Manger on 5/29/17.
//  Copyright © 2017 Joss Manger. All rights reserved.
//

#if arch(i386) || arch(x86_64)
    let simulator = true;
#else
    let simulator = false;
#endif

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

func minutes(to date: Date) -> Int {
    return Calendar.current.dateComponents([.minute], from: Date.init(), to: date).minute ?? 0
}




class BatteryLevelHelper : NSObject {
    
    var session:WCSession!
    var ready:NSNumber!
    var levelFloat:NSNumber!
    var status:NSNumber!
    var date:NSDate!
    var name:NSString!
    var delegate:BatteryLevelHelperDelegate?
    
    override init(){
        super.init()
        
        ready = NSNumber.init(booleanLiteral: false);
        print(ready)
        session = WCSession.default()
        
    }
    
    func sendRequestMessage(){
        print("simulator: \(simulator)");
        var requestDict:[String:Any]!
        
        if(simulator){
            requestDict = ["request":"dummyBatteryLevelandStatus"];
        } else {
            requestDict = ["request":"currentBatteryLevelandStatus"];
        }
        
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
        name = message["deviceName"] as! NSString;
        ready = NSNumber.init(booleanLiteral: true);
        print(ready)
        print(date,status,levelFloat)
        delegate?.dataReady()
    }
    
    private func error(message:Error){
        print("error: \(message)")
    }
    
    @objc func estimateLevel(date:NSDate)->NSNumber{
        
        print(date)
        
        let datecompare = minutes(to: date as Date)
        
        let rate = 0.005;
        
        var returnfloat:Float;
        
        if(status == 2){
            returnfloat = levelFloat.floatValue + Float((rate * Double(datecompare)))
        } else {
            returnfloat = levelFloat.floatValue - Float((rate * Double(datecompare)))
        }
        
        if(returnfloat>1.0){
            return NSNumber.init(floatLiteral: 1.0)
        } else if (returnfloat<0.1){
            return NSNumber.init(floatLiteral: 0.0)
        } else {
            return NSNumber.init(value: returnfloat)
        }
        
    }
    
}
