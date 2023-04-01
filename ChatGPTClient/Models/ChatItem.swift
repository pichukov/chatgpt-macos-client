import Foundation

struct ChatItem {
    let id: String = UUID().uuidString
    let date: Date
    let role: Role
    let blocks: [TextBlock]
    let raw: String
}
