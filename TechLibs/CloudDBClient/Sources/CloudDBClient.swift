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

struct DefaultCloudDBClient: CloudDBClient {
    
    private let firestore = Firestore.firestore()
    
    func fetch<T: Decodable>(_ decodableType: T.Type, table: CloudDBTable, id: String) async -> Result<T, Error> {
        do {
            let documentSnapshot = try await firestore.collection(table.rawValue).document(id).getDocument()
            return .success(try documentSnapshot.data(as: decodableType))
        } catch {
            return .failure(error)
        }
    }
    
    func delete(table: CloudDBTable, id: String) async throws {
        try await firestore.collection(table.rawValue).document(id).delete()
    }
    
    func create<T: Encodable & Identifiable>(_ encodable: T, table: CloudDBTable) async throws where T.ID == String {
        let encodedData = try Firestore.Encoder().encode(encodable)
        try await firestore.collection(table.rawValue).document(encodable.id).setData(encodedData, merge: true)
    }
}
