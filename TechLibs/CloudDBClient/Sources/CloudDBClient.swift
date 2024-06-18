//
//  CloudDBClient.swift
//
//
//  Created by Hugues Fils on 18/06/2024.
//

import FirebaseFirestore

public protocol CloudDBClient {
    func fetch<T: Decodable>(_ decodableType: T.Type, table: CloudDBTable, id: String) async -> Result<T, Error>
    func delete(table: CloudDBTable, id: String) async throws
    func create<T: Encodable & Identifiable>(_ encodableType: T, table: CloudDBTable) async throws where T.ID == String
}

public struct DefaultCloudDBClient: CloudDBClient {
    public init() {}
    
    public func fetch<T: Decodable>(_ decodableType: T.Type, table: CloudDBTable, id: String) async -> Result<T, Error> {
        do {
            let documentSnapshot = try await Firestore.firestore().collection(table.rawValue).document(id).getDocument()
            
            return .success(try documentSnapshot.data(as: decodableType))
        } catch {
            return .failure(error)
        }
    }
    
    public func delete(table: CloudDBTable, id: String) async throws {
        try await Firestore.firestore().collection(table.rawValue).document(id).delete()
    }
    
    public func create<T: Encodable & Identifiable>(_ encodable: T, table: CloudDBTable) async throws where T.ID == String {
        let encodedData = try Firestore.Encoder().encode(encodable)
        try await Firestore.firestore().collection(table.rawValue).document(encodable.id).setData(encodedData, merge: true)
    }
}
