//
//  NearestSettlementService.swift
//  TravelSchedule
//
//  Created by Dmitry Zherebyatnikov on 20.11.2026.
//

import Logging

typealias NearestSettlement = Components.Schemas.NearestSettlementResponse

protocol NearestSettlementServiceProtocol {
    func getNearestSettlement(lat: Double, lng: Double) async throws
        -> NearestSettlement
}

final class NearestSettlementService: NearestSettlementServiceProtocol {

    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getNearestSettlement(lat: Double, lng: Double) async throws
        -> NearestSettlement
    {
        let response = try await client.getNearestSettlement(
            query: .init(
                apikey: apikey,
                lat: lat,
                lng: lng
            )
        )

        return try response.ok.body.json
    }
}

func testFetchNearestSettlement() {
    Task {
        let logger = Logger(label: "TravelSchedule.fetchSettlement")
        do {
            let dependencies = try YandexRaspDependencies.make()

            let service = NearestSettlementService(
                client: dependencies.client,
                apikey: dependencies.apiKey
            )

            logger.info("Fetching settlement...")
            let settlement = try await service.getNearestSettlement(
                lat: 59.864177,  // Пример координат
                lng: 30.319163  // Пример координат
            )

            print("Successfully fetched settlement: \(settlement)")  //оставил print для запуска с Canvas
        } catch {
            logger.error("Error fetching settlement: \(error)")
        }
    }
}
