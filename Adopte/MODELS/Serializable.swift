//
//  Serializable.swift
//  Adopte
//
//  Created by Faustin Veyssiere on 05/05/2021.
//

import Foundation

internal enum SerializableError: Error {
    case `default`(message: String)
    case cannotRead(message: String? = "Error! When you want to read your data in local.")
    case cannotWrite(message: String? = "Error! When you want to write your data in local.")
}

public protocol Serializable: Codable {
    func JSONString() -> String?
    func dictionary() -> [String: AnyObject]?
    func data() -> Data?
    static func decode<Self: Decodable>(data: Data) throws -> Self?
}

extension Serializable {

    // MARK: - Public methods
    
    /**
     Method to get a json of the current instance of a Codable variable
     
     - Returns: json contained the current values of an instance conform to the Codable protocol
     
     */
    public func JSONString() -> String? {
        if let data = self.data() {
            let JSONString = String(data: data, encoding: .utf8)
            return JSONString
        }
        return nil
    }
    
    /**
     Method to print a pretty json in the console of the current instance of a Codable variable. Usefull for debuging
     */
    public func prettyJSON() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self),
            let jsonString = String(data: data, encoding: .utf8)
            else { return }
        print(jsonString)
    }
    
    /**
     Method to get a dictionary of the current instance of a Codable variable
     
     - Returns: dictionary contained the current values of an instance conform to the Codable protocol
     
     */
    public func dictionary() -> [String: AnyObject]? {
        guard let data = try? JSONEncoder().encode(self),
            let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
            else { return nil }
        return result
    }
    
    /**
     Method to export data of your current instance of a Codable variable
     
     - Returns: a data with your current model encoded
     
     */
    public func data() -> Data? {
        return try? _data()
    }
    
    /**
     Method to write data in local
     
     - Parameter to: url where you save data in local
     
     */
    public func write(to fileUrl: URL) throws {
        // I don't think we need that because if you set atomically to true he keep the last version of the file before rewrite it
//        if _fileExist(at: fileUrl.path) {
//            try FileManager.default.removeItem(atPath: fileUrl.path)
//        }
        if let data = self.JSONString() {
            do {
                try data.write(to: fileUrl, atomically: true, encoding: .utf8)
            } catch let error {
                throw error
            }
        } else {
            throw SerializableError.default(message: "Error! When you want to transform your data in JSONString.")
        }
    }
    
    /**
     Method to read data in local
     
     - Parameter to: url where you get data in local
     
     */
    public func read(to fileUrl: URL) throws -> Data {
        guard _fileExist(at: fileUrl) else {
            throw SerializableError.cannotRead(message: "Error! The Document doesn't exist at this path: \(fileUrl.path).")
        }
        
        // load data
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            return data
        } catch let error {
            throw SerializableError.cannotRead(message: error.localizedDescription)
        }
    }
    
    /**
     Method to inport data from json
     
     - Parameter data: data of the model
     - Returns: an instance of data typed by the class of type in type variable 😑
     
     */
    public static func decode<Self: Decodable>(data: Data) throws -> Self {
        
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(Self.self, from: data)
            return decoded
        } catch let error {
            print("Failed to decode JSON: \(error)")
            throw error
        }
    }
    
    
    // MARK: - Private methods
    
    /**
    Convenience method to check if a file exist at a given path
    
    - Parameter at path: path until a local file
    - Returns: a Boolean if the file exist
    
    */
    private func _fileExist(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    /**
    Convenience method to check if a file exist at a given path
    
    - Parameter at url: URL until a local file
    - Returns: a Boolean if the file exist
    
    */
    private func _fileExist(at url: URL) -> Bool {
        return _fileExist(at: url.path)
    }
    
    /**
     Method to export data of your current instance of a Codable variable
     
     - Returns: a data with your current model encoded
     
     */
    private func _data() throws -> Data {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            return jsonData
        } catch let error {
            throw SerializableError.default(message: "Failed to encode \(self) in json: \(error.localizedDescription)")
        }
    }
}
