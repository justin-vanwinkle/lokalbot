import XCTest
@testable import LokalBot

final class QuickRecallRowModelTests: XCTestCase {
    func testSavedCaptureUsesItsOwnExcerptAndReplacesItsSourceGroup() {
        let rows = QuickRecallRowModel.screens(
            groups: [
                ScreenRecallGroup(id: "slack", matches: [
                    hit(1, snippet: "The primary «Redis» capture"),
                    hit(2, snippet: "The saved «Redis» decision"),
                ]),
                ScreenRecallGroup(id: "safari", matches: [hit(3, snippet: "«Redis» review")]),
            ],
            savedMoments: [saved(2)], hasQuery: true)

        XCTAssertEqual(rows.map(\.snapshotID), [2, 3])
        XCTAssertTrue(rows[0].isSaved)
        XCTAssertEqual(rows[0].snippet, "The saved «Redis» decision")
        XCTAssertFalse(rows[1].isSaved)
    }

    func testQueryDoesNotIncludeSavedMomentsOutsideSearchMatches() {
        let rows = QuickRecallRowModel.screens(
            groups: [ScreenRecallGroup(id: "match", matches: [hit(1, snippet: "«Redis» review")])],
            savedMoments: [saved(99)], hasQuery: true)

        XCTAssertEqual(rows.map(\.snapshotID), [1])
        XCTAssertFalse(rows[0].isSaved)
    }

    func testEmptyQueryShowsOnlyRecentSavedMoments() {
        let rows = QuickRecallRowModel.screens(
            groups: [ScreenRecallGroup(id: "old-query", matches: [hit(99, snippet: "Old result")])],
            savedMoments: (1...15).map { saved(Int64($0)) }, hasQuery: false)

        XCTAssertEqual(rows.map(\.snapshotID), (1...12).map { Int64($0) })
        XCTAssertTrue(rows.allSatisfy(\.isSaved))
        XCTAssertTrue(rows.allSatisfy { $0.snippet == nil })
    }

    func testSavedAccessibilityValueIncludesStatusWithoutSearchMarkers() {
        let rows = QuickRecallRowModel.screens(
            groups: [ScreenRecallGroup(id: "saved", matches: [hit(1, snippet: "«Redis» decision")])],
            savedMoments: [saved(1)], hasQuery: true)

        XCTAssertEqual(rows[0].accessibilityValue, "Saved. Slack. Redis decision")
    }

    private func hit(_ id: Int64, snippet: String) -> ActivityStore.OCRHit {
        ActivityStore.OCRHit(snapshotID: id, ts: Date(timeIntervalSince1970: 1_700_000_000),
                             app: "Slack", windowTitle: "Engineering", snippet: snippet)
    }

    private func saved(_ id: Int64) -> ActivityStore.SavedMoment {
        ActivityStore.SavedMoment(snapshotID: id, ts: Date(timeIntervalSince1970: 1_700_000_000),
                                  path: "", app: "Slack", windowTitle: "Engineering",
                                  trigger: "manual", note: "Benchmark decision", createdAt: Date())
    }
}
