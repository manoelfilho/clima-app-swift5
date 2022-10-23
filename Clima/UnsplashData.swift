import Foundation

// MARK: - GeometryGeocoderResponse
struct UnsplashModel: Codable {
    let total: Int?
    let totalPages: Int?
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let urls: Urls?
}

// MARK: - Urls
struct Urls: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    let smallS3: String?
}
