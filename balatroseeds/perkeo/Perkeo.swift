//
//  Perkeo.swift
//  balatroseeds
//
//  Created by Alex on 16/03/25.
//
import Foundation
import SwiftUI


class ItemEdition : Item, Encodable, ObservableObject {

    let item : Item
    let ante : Int
    @Published var edition : Edition
    
    init(item: Item) {
        self.item = item
        self.ante = 0
        self.edition = .NoEdition
        
        if item is ItemEdition {
            fatalError("Revursive ItemEdition not yet supported")
        }
    }
    
    func nextEdition() {
        switch(edition){
        case .NoEdition:
            edition = .Negative
        case .Negative:
            edition = .Foil
        case .Foil:
            edition = .Holographic
        case .Holographic:
            edition = .Polychrome
        case .Polychrome:
            edition = .NoEdition
        default:
            break
        }
    }
    
    func sprite() -> SpriteImageView {
        return item.sprite(edition: edition)
    }
    
    var rawValue: String {
        get {
            item.rawValue
        }
    }
    
    enum CodingKeys: CodingKey {
        case sticker
        case item
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if  edition != .NoEdition {
            try container.encode(edition, forKey: .sticker)
        }
        try container.encode(item.rawValue, forKey: .item)
    }
    
    
    var y : Int {
        get {
            item.y
        }
    }
    
    var ordinal : Int {
        get {
            item.ordinal
        }
    }
}

struct DataItem {
    let seed : String
    let score : Int
    let data : [Int]
    
    func isOn(_ item : ItemEdition) -> Bool {
        for value in data {
            let yIndex = (value >> 24) & 0xFF
            
            if yIndex != item.y {
                continue
            }
            
            let ordinal = (value >> 16) & 0xFF
            
            if ordinal != item.ordinal {
                continue
            }
            
            if item.ante == 0 && item.edition == .NoEdition {
                return true
            }
            
            let edition = (value >> 8) & 0xFF
            
            if item.edition.ordinal != edition {
                continue
            }
            
            let ante = value & 0xFF
            
            if ante > item.ante {
                continue
            }
            
            return true
        }
        
        return false
    }
}

class JokerFile : ObservableObject {
    
    var jokerData : [DataItem] = []
    
    var isEmpty : Bool {
        get {
            jokerData.isEmpty
        }
    }
    
    func search(_ items: [ItemEdition]) -> [String:Int] {
        var result = [String:Int]()
        
        for joker in jokerData {
            if result.count > 100 {
                break
            }
            
            var add = true
            
            for item in items {
                if !joker.isOn(item) {
                    add = false
                    break
                }
            }
            
            if add {
                result[joker.seed] = joker.score
            }
        }
        
        return result
    }
    
    
    func read() -> [DataItem] {
        if !jokerData.isEmpty {
            return jokerData
        }
        
        guard let url = Bundle.main.url(forResource: "perkeo", withExtension: "jkr") else {
            print("not found")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            jokerData = try read(from: InputStream(data: data))
            return jokerData
        }catch {
            print(error)
        }
        
        return []
    }
    
    private func read(from inputStream: InputStream) throws -> [DataItem] {
        var dataList: [DataItem] = []
        let seedLength = 7
        var seedBuffer = [UInt8](repeating: 0, count: seedLength)
        var intBuffer = [UInt8](repeating: 0, count: 4) // Int.bitWidth / 8
        
        inputStream.open()
        defer { inputStream.close() }
        
        while inputStream.read(&seedBuffer, maxLength: seedLength) == seedLength {
            guard let seed = String(bytes: seedBuffer, encoding: .utf8) else {
                throw NSError(domain: "DataReaderError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode seed"])
            }
            
            if (seed.range(of: "^[a-zA-Z0-9]{7}$", options: .regularExpression) == nil){
                throw NSError(domain: "DataReaderError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid seed: '\(seed)'"])
            }
            
            try read(from: inputStream, into: &intBuffer)
            
            intBuffer.reverse()
            
            let score = intBuffer.withUnsafeBytes { $0.load(as: Int32.self) }
            
            try read(from: inputStream, into: &intBuffer)
            
            intBuffer.reverse()
            
            let dataSize = intBuffer.withUnsafeBytes { $0.load(as: Int32.self) }
            
            var data: [Int] = []
            for _ in 0..<Int(dataSize) {
                try read(from: inputStream, into: &intBuffer)
                intBuffer.reverse()
                let value = intBuffer.withUnsafeBytes { $0.load(as: Int32.self) }
                data.append(Int(value))
            }
            
            dataList.append(DataItem(seed: seed, score: Int(score), data: data))
        }
        
        return dataList
    }
    
    private  func read(from inputStream: InputStream, into buffer: inout [UInt8]) throws {
        let bytesToRead = buffer.count
        let bytesRead = inputStream.read(&buffer, maxLength: bytesToRead)
        
        if bytesRead != bytesToRead {
            throw NSError(domain: "DataReaderError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to read expected number of bytes"])
        }
    }
    /*
     public static @NotNull List<Data> read(@NotNull InputStream bis) throws IOException {
     List<Data> dataList = new ArrayList<>();
     byte[] seedBytes = new byte[7];
     byte[] intBytes = new byte[Integer.BYTES];
     ByteBuffer intBuffer = ByteBuffer.allocate(Integer.BYTES);
     
     while (bis.read(seedBytes) != -1) {
     String seed = new String(seedBytes);
     if (!seed.matches("[a-zA-Z0-9]{7}")) {
     throw new IllegalStateException("Invalid seed: '" + seed + "'");
     }
     
     read(bis, intBytes);
     intBuffer.clear();
     intBuffer.put(intBytes);
     int score = intBuffer.getInt(0);
     
     read(bis, intBytes);
     intBuffer.clear();
     intBuffer.put(intBytes);
     int dataSize = intBuffer.getInt(0);
     
     int[] data = new int[dataSize];
     
     for (int i = 0; i < dataSize; i++) {
     read(bis, intBytes);
     intBuffer.clear();
     intBuffer.put(intBytes);
     data[i] = intBuffer.getInt(0);
     }
     
     dataList.add(new Data(seed, score, data));
     }
     
     return dataList;
     }
     */
}
