struct TextBlock {
    let value: String
    let type: BlockType
}

enum BlockType {
    case text
    case code
}
