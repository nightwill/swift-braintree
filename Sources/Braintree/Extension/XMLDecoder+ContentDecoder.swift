import XMLParsing
import Vapor

extension XMLDecoder: ContentDecoder {

    public func decode<D>(_ decodable: D.Type, from body: NIOCore.ByteBuffer, headers: NIOHTTP1.HTTPHeaders) throws -> D where D : Decodable {
        let data = body.getData(at: body.readerIndex, length: body.readableBytes) ?? Data()
        print(String(data: data, encoding: .utf8) ?? "")
        return try self.decode(D.self, from: data)
    }

}
