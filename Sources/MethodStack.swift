//
//  MethodStack.swift
//  MonitorKit
//
//  Created by 马陈爽 on 2023/7/10.
//

import Foundation
import CrashReporter

class MethodStack {
    private let crashReporter: PLCrashReporter
    let dumpQueue: DispatchQueue
    init() {
        let config = PLCrashReporterConfig(signalHandlerType: .BSD, symbolicationStrategy: .all)
        crashReporter = PLCrashReporter(configuration: config)
        dumpQueue = DispatchQueue(label: "com.machenshuang.cation.dump", qos: .background)
    }
    
    func fetchMethodStack(_ completion: @escaping ((String?)->Void)) {
        self.dumpQueue.async { [weak self] in
            guard let `self` = self else { return }
            let data = self.crashReporter.generateLiveReport()
            do {
                let lagReport = try PLCrashReport(data: data)
                let lagReportString = PLCrashReportTextFormatter.stringValue(for: lagReport, with: .init(0))
                completion(lagReportString)
            } catch {
                debugPrint("error = \(error.localizedDescription)")
            }
        }
        
    }
}
