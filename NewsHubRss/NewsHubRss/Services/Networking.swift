//
//  Networking.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 24.04.23.
//

import Foundation

struct NetworkError: Error {}

struct Networking {
    static func getRSSPageOfSite(by url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        let session = URLSession(configuration: .ephemeral)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NetworkError()))
                }
                return
            }

            if let data = data, let stringData = String(data: data, encoding: .utf8) {
                completion(.success(stringData))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(NetworkError()))
            }
        }
        dataTask.resume()
    }

    static func detectRssFeed(by url: URL, completion: @escaping (_ isRSS: Bool) -> Void) {
        let session = URLSession(configuration: .ephemeral)
        var request = URLRequest(url: url)
        request.httpMethod = "Head"
        let dataTask = session.dataTask(with: request) { (_, response, _) in
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let contentType = httpResponse.allHeaderFields["Content-Type"] as? String else {
                completion(false)
                return
            }

            completion(contentType.hasPrefix("application/rss+xml") || contentType.hasPrefix("application/xml"))
        }

        dataTask.resume()
    }
}
