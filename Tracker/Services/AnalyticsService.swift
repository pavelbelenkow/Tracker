//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Pavel Belenkow on 16.08.2023.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    
    static func activate() {
        let apiKey = "267c623b-ea45-4b78-acbe-fa785030cbcc"
        
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: apiKey) else {
            return
        }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: String, params: [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params) { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        }
    }
}
