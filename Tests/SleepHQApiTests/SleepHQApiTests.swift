import XCTest
@testable import SleepHQApi

final class SleepHQApiTests: XCTestCase {
    func testCanCreateApi() async throws {
        let api: SleepHQApi = SleepHQProdApi()
        XCTAssertNotNil(api)
    }
}
