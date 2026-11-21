//
//  ThreadService.swift
//  TravelSchedule
//
//  Created by Dmitry Zherebyatnikov on 20.11.2026.
//

import Logging

typealias ThreadStationsResponse = Components.Schemas.ThreadStationsResponse

protocol ThreadServiceProtocol {
    func getRouteStations(uid: String)
        async throws -> ThreadStationsResponse
}

final class ThreadService: ThreadServiceProtocol {

    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getRouteStations(uid: String)
        async throws -> ThreadStationsResponse
    {

        let response = try await client.getRouteStations(
            query: .init(
                apikey: apikey,
                uid: uid
            )
        )
        return try response.ok.body.json
    }
}

func testFetchThreadService() {
    Task {
        let logger = Logger(label: "TravelSchedule.fetchThreadService")
        do {
            let dependencies = try YandexRaspDependencies.make()

            let service = ThreadService(
                client: dependencies.client,
                apikey: dependencies.apiKey
            )

            logger.info("Fetching route stations...")
            let stations = try await service.getRouteStations(
                uid: "7111_0_9602498_g25_4"
            )

            print("Successfully fetched route stations: \(stations)")  //оставил print для запуска с Canvas
        } catch {
            logger.error("Error fetching route stations: \(error)")
        }
    }
}
