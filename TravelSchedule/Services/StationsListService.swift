//
//  StationsListService.swift
//  TravelSchedule
//
//  Created by Dmitry Zherebyatnikov on 20.11.2026.
//

import Foundation
import Logging
import OpenAPIRuntime

typealias AllStationsResponse = Components.Schemas.AllStationsResponse

protocol StationsListServiceProtocol {
    func getAllStations() async throws -> AllStationsResponse
}

final class StationsListService: StationsListServiceProtocol {

    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getAllStations() async throws -> AllStationsResponse {
        let response = try await client.getAllStations(
            query: .init(
                apikey: apikey
            )
        )
        let body = try response.ok.body.text_html_charset_utf_hyphen_8

        let data = try await Data(
            collecting: body,
            upTo: 100 * 1024 * 1024
        )

        return try JSONDecoder().decode(AllStationsResponse.self, from: data)
    }

}

func testStationsList() {
    Task {
        let logger = Logger(label: "TravelSchedule.fetchStationsList")

        do {
            let dependencies = try YandexRaspDependencies.make()

            let service = StationsListService(
                client: dependencies.client,
                apikey: dependencies.apiKey
            )
            logger.info("Fetching stations list...")
            let stations = try await service.getAllStations()
            print("Countries: \(stations.countries?.count ?? 0)")

            if let country = stations.countries?.first {
                print("First country: \(country.title ?? "Unknown")")
                print("Regions: \(country.regions?.count ?? 0)")
            }  //оставил print для запуска с Canvas
        } catch {
            logger.error("Error fetching stations list: \(error)")
        }
    }
}
