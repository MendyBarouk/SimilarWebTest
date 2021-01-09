//
//  BringJsonOperation.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 08/01/2021.
//

import UIKit
import ProcedureKit
import ProcedureKitNetwork

class BringJsonOperation<T:Decodable>: GroupProcedure, OutputProcedure {
    
    private let lock = NSLock()
    
    typealias Output = T
    private var _output: Pending<ProcedureResult<T>> = .pending
    var output: Pending<ProcedureResult<T>> {
        get { return lock.withCriticalScope { _output } }
        set
        {
            lock.withCriticalScope {
                _output = newValue
            }
        }
    }
    
    init(session: URLSession = URLSession.shared, requestOperation: NetworkRequestOperation<T>) {
        let networkDataProcedure = NetworkDataProcedure(session: session).injectResult(from: requestOperation)
        let transformProcedure = TransformProcedure<Data,T> {
            try JSONDecoder().decode(T.self, from: $0)
        }.injectPayload(fromNetwork: networkDataProcedure)
                        
        super.init(operations: [requestOperation,networkDataProcedure,transformProcedure])
        
        bind(from: transformProcedure)
    }
}
