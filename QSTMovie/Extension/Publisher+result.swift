//
//  Publisher+result.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/2/23.
//

import Combine

extension Publisher {
    func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map(Result.success)
            .catch { error in
                Just(.failure(error))
            }
            .eraseToAnyPublisher()
    }
}
