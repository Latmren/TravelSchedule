//
//  CopyrightService.swift
//  TravelSchedule
//
//  Created by Dmitry Zherebyatnikov on 18.11.2026.
//

import Logging

typealias CopyrightResponse = Components.Schemas.CopyrightResponse

protocol CopyrightServiceProtocol {
    func getCopyright() async throws -> CopyrightResponse
}

final class CopyrightService: CopyrightServiceProtocol {

    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getCopyright() async throws -> CopyrightResponse {
        let response = try await client.getCopyright(
            query: .init(
                apikey: apikey
            )
        )
        return try response.ok.body.json
    }

}

func testFetchCopyright() {
    Task {
        let logger = Logger(label: "TravelSchedule.fetchCopyright")

        do {
            let dependencies = try YandexRaspDependencies.make()

            let service = CopyrightService(
                client: dependencies.client,
                apikey: dependencies.apiKey
            )
            logger.info("Fetching copyright...")
            let copyright = try await service.getCopyright()
            print(
                "Successfully fetched copyright: \(copyright)"
            )  //оставил print для запуска с Canvas
        } catch {
            logger.error("Error fetching copyright: \(error)")
        }
    }
}
