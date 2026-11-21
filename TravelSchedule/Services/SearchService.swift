//
//  SearchService.swift
//  TravelSchedule
//
//  Created by Dmitry Zherebyatnikov on 20.11.2026.
//

import Logging

typealias Segments = Components.Schemas.Segments

protocol SearchServiceProtocol {
    func getScheduleBetweenStations(from: String, to: String)
        async throws -> Segments
}

final class SearchService: SearchServiceProtocol {

    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getScheduleBetweenStations(from: String, to: String)
        async throws -> Segments
    {

        let response = try await client.getScheduleBetweenStations(
            query: .init(
                apikey: apikey,
                from: from,
                to: to
            )
        )
        return try response.ok.body.json
    }
}

func testSearchService() {
    Task {
        let logger = Logger(label: "TravelSchedule.fetchSearchService")
        do {
            let dependencies = try YandexRaspDependencies.make()

            let service = SearchService(
                client: dependencies.client,
                apikey: dependencies.apiKey
            )

            logger.info("Fetching search results...")
            let search = try await service.getScheduleBetweenStations(
                from: "s9602498",
                to: "s9603500"
            )

            print("Successfully fetched search results: \(search)")  //оставил print для запуска с Canvas
        } catch {
            logger.error("Error fetching search results: \(error)")
        }
    }
}
