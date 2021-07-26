//
//  APICaller.swift
//  NewsAppClassic
//
//  Created by Lucas Parreira on 23/07/21.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadLinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=US&apiKey=7dab970fbb0f4a008dec40ba96538c70")
        static let searchURLString = "https://newsapi.org/v2/everything?q="
        static let apiKey = "&apiKey=7dab970fbb0f4a008dec40ba96538c70"
    }
    
    private init(){}
    
    public func getTopStories(completion: @escaping (Result<[Article],Error>) -> Void){
        guard let url = Constants.topHeadLinesURL else {
            return
        }
        
        URLSession.shared.dataTask(with: url){ data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    completion(.success(result.articles))
                    
                } catch {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
    
    public func search(with query: String, completion: @escaping (Result<[Article],Error>) -> Void){
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
           return
        }
        let urlString = Constants.searchURLString + query + Constants.apiKey
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url){ data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    completion(.success(result.articles))
                    
                } catch {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
}

// Models

struct APIResponse : Codable {
    let articles: [Article]
}

struct Article : Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
