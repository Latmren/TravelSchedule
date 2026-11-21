//
//  NearestStationsService.swift
//  TravelSchedule
//
//  Created by Dmitry Zherebyatnikov on 18.11.2026.
//

import Logging

typealias NearestStations = Components.Schemas.Stations

protocol NearestStationsServiceProtocol {
    func getNearestStations(lat: Double, lng: Double, distance: Int)
        async throws -> NearestStations
}

final class NearestStationsService: NearestStationsServiceProtocol {

    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getNearestStations(lat: Double, lng: Double, distance: Int)
        async throws -> NearestStations
    {
        let response = try await client.getNearestStations(
            query: .init(
                apikey: apikey,  // Передаём API-ключ
                lat: lat,  // Передаём широту
                lng: lng,  // Передаём долготу
                distance: distance  // Передаём дистанцию
            )
        )
        return try response.ok.body.json
    }
}

func testFetchStations() {
    Task {
        let logger = Logger(label: "TravelSchedule.fetchStations")
        do {
            let dependencies = try YandexRaspDependencies.make()

            let service = NearestStationsService(
                client: dependencies.client,
                apikey: dependencies.apiKey
            )

            logger.info("Fetching stations...")
            let stations = try await service.getNearestStations(
                lat: 59.864177,
                lng: 30.319163,
                distance: 50
            )

            print("Successfully fetched stations: \(stations)")  //оставил print для запуска с Canvas
        } catch {
            logger.error("Error fetching stations: \(error)")
        }
    }
}
