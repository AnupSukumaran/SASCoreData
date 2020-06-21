import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SASCoreDataTests.allTests),
    ]
}
#endif
