//
//  YandexRaspDependencies.swift
//  TravelSchedule
//
//  Created by Dmitry Zherebyatnikov on 19.11.2026.
//

import Foundation
import OpenAPIURLSession

enum ConfigurationError: Error {
    case missingAPIKey
}

struct YandexRaspDependencies {
    let client: Client
    let apiKey: String

    static func make() throws -> YandexRaspDependencies {

        guard
            let apiKey = Bundle.main.object(
                forInfoDictionaryKey: "YandexRaspAPIKey"
            ) as? String,
            !apiKey.isEmpty
        else {
            throw ConfigurationError.missingAPIKey
        }

        let client = Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        )

        return YandexRaspDependencies(client: client, apiKey: apiKey)
    }
}
