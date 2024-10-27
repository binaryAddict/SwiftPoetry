//
//  DispatchQueue+Extensions.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import Foundation

extension DispatchQueue {
    func throwingAsyncAwait<T>(operation: @escaping () async throws -> T, completion: @escaping (Result<T, Error>) -> Void) {
        Task {
            func action(_ result: Result<T, Error>) {
               self.async {
                   completion(result)
               }
            }
            do {
                action(.success(try await operation()))
            } catch {
                action(.failure(error))
            }
        }
    }
    
    func asyncAwait<T>(operation: @escaping () async -> T, completion: @escaping (T) -> Void) {
        Task {
            let value = await operation()
            self.async {
                completion(value)
            }
        }
    }
}
