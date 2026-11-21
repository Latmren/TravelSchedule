//
//  JSONChackHelper.swift
//  TravelSchedule
//
//  Created by Dmitry Zherebyatnikov on 21.11.2026.
//
import Foundation

func debugScheduleResponse(stationCode: String) {
    Task {
        do {
            let dependencies = try YandexRaspDependencies.make()

            var components = URLComponents(
                string: "https://api.rasp.yandex.net/v3.0/thread/"
            )!

            components.queryItems = [
                URLQueryItem(name: "apikey", value: dependencies.apiKey),
                URLQueryItem(name: "uid", value: stationCode),
                URLQueryItem(name: "format", value: "json")
            ]

            let (data, response) = try await URLSession.shared.data(
                from: components.url!
            )

            let status = (response as? HTTPURLResponse)?.statusCode
            print("HTTP status:", status ?? 0)

            let rawJSON = String(decoding: data, as: UTF8.self)
            print(rawJSON)

        } catch {
            print("Debug request failed: \(error)")
        }
    }
}
