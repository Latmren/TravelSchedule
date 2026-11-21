//
//  CarrierService.swift
//  TravelSchedule
//
//  Created by Dmitry Zherebyatnikov on 20.11.2026.
//

import Logging

typealias CarrierResponse = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol {
    func getCarrier(carrierCode: String)
        async throws -> CarrierResponse
}

final class CarrierService: CarrierServiceProtocol {

    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getCarrier(carrierCode: String)
        async throws -> CarrierResponse
    {

        let response = try await client.getCarrierInfo(
            query: .init(
                apikey: apikey,
                code: carrierCode
            )
        )
        return try response.ok.body.json
    }
}

func testFetchCarrier() {
    Task {
        let logger = Logger(label: "TravelSchedule.fetchCarrier")
        do {
            let dependencies = try YandexRaspDependencies.make()

            let service = CarrierService(
                client: dependencies.client,
                apikey: dependencies.apiKey
            )

            logger.info("Fetching carrier...")
            let carrier = try await service.getCarrier(
                carrierCode: "8565"
            )

            print("Successfully fetched carrier: \(carrier)")  //оставил print для запуска с Canvas
        } catch {
            logger.error("Error fetching carrier: \(error)")
        }
    }
}
