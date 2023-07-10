//
//  CatonMonitor.swift
//  MonitorKit
//
//  Created by 马陈爽 on 2023/7/10.
//

import Foundation
import Dispatch

public typealias CatonStackCallback = ((String?)->Void)

public class CatonMonitor {
    private var runLoopObserver: CFRunLoopObserver?
    
    let monitorQueue: DispatchQueue
    let semaphore: DispatchSemaphore
    private var runLoopActivity: CFRunLoopActivity
    private var monitorTime: Double = 10
    
    private let methodStack: MethodStack
    
    public static let shared = CatonMonitor()
    
    public var catonStackCallback: CatonStackCallback?
    
    private init() {
        semaphore = DispatchSemaphore(value: 0)
        monitorQueue = DispatchQueue(label: "com.machenshuang.caton.monitor")
        methodStack = MethodStack()
        runLoopActivity = .entry
    }
    
    public func changeObserverTime(_ time: Double) {
        monitorTime = time
    }
    
    public func startMonitor() {
        
        if runLoopObserver == nil {
            runLoopObserver = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.allActivities.rawValue, true, 0, { [weak self] (observer, activity) -> Void in
                guard let `self` = self else { return }
                self.runLoopActivity = activity
                self.semaphore.signal()
            })
            CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver!, .commonModes)
        }
        
        monitorQueue.async { [weak self] in
            guard let `self` = self else { return }
            while true {
                let semaphoreWait = self.semaphore.wait(timeout: .now()+monitorTime)
                if semaphoreWait == .timedOut {
                    if self.runLoopObserver == nil {
                        return
                    }
                    if self.runLoopActivity == .beforeSources || self.runLoopActivity == .afterWaiting {
                        debugPrint("CotonMonitor 超时且发生卡顿")
                        if let callback = self.catonStackCallback {
                            self.methodStack.fetchMethodStack(callback)
                        }
                    }
                }
            }
        }
    }
    
    public func stopMonitor() {
        
        if let _ = self.runLoopObserver {
            CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.runLoopObserver!, .commonModes)
            self.runLoopObserver = nil
        }
        
    }
    
}

