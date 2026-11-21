//
//  ScheduleService.swift
//  TravelSchedule
//
//  Created by Dmitry Zherebyatnikov on 20.11.2026.
//

import Logging

typealias StationScheduleResponse = Components.Schemas.ScheduleResponse

protocol ScheduleServiceProtocol {
    func getSchedule(stationCode: String)
        async throws -> StationScheduleResponse
}

final class ScheduleService: ScheduleServiceProtocol {

    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getSchedule(stationCode: String)
        async throws -> StationScheduleResponse
    {

        let response = try await client.getStationSchedule(
            query: .init(
                apikey: apikey,
                station: stationCode
            )
        )
        return try response.ok.body.json
    }
}

func testFetchSchedule() {
    Task {
        let logger = Logger(label: "TravelSchedule.fetchSchedule")
        do {
            let dependencies = try YandexRaspDependencies.make()

            let service = ScheduleService(
                client: dependencies.client,
                apikey: dependencies.apiKey
            )

            logger.info("Fetching schedule...")
            let schedule = try await service.getSchedule(
                stationCode: "s9600213"
            )

            print("Successfully fetched schedule: \(schedule)")  //оставил print для запуска с Canvas
        } catch {
            logger.error("Error fetching schedule: \(error)")
        }
    }
}
