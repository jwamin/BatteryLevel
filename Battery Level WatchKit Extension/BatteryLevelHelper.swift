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

@objc public protocol BatteryLevelHelperDelegate{
    func dataReady();
}

func minutes(to date: Date) -> Int {
    return Calendar.current.dateComponents([.minute], from: Date.init(), to: date).minute ?? 0
}

public class BatteryLevelHelper : NSObject {
    
    @objc public private(set) var session:WCSession!
    @objc public private(set) var ready:NSNumber!
    @objc public private(set) var levelFloat:NSNumber!
    @objc public private(set) var status:NSNumber!
    @objc public private(set) var date:NSDate!
    @objc public private(set) var name:NSString!
    @objc public var delegate:BatteryLevelHelperDelegate?
    
    override init(){
        super.init()
        
        ready = NSNumber.init(booleanLiteral: false);
        print(ready)
        session = WCSession.default
        
    }
    
    @objc public func sendRequestMessage(){
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
    
    @objc func setInstanceVariables(message:[String : Any]){
        date = message["currentDate"] as? NSDate;
        status = message["batteryStatus"] as? NSNumber;
        levelFloat = message["currentLevelFloat"] as? NSNumber;
        name = message["deviceName"] as? NSString;
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
        
        let increment = Float((rate * Double(datecompare)))
        
        guard let level = levelFloat else {
            return NSNumber(floatLiteral: 0.0)
        }
        
        let floatval = level.floatValue
        
        switch status {
            case 2:
                returnfloat = floatval + increment
            default:
                returnfloat = floatval - increment
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
