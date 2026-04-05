import XCTest
@testable import SpoofTrap

@MainActor
final class BypassViewModelTests: XCTestCase {

    var viewModel: BypassViewModel!

    override func setUp() {
        super.setUp()
        // Reset user defaults/stored settings might be necessary if they interfere,
        // but for applyPreset it just modifies the Published properties directly.
        viewModel = BypassViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testApplyPresetStable() {
        // Given
        viewModel.applyPreset(.custom) // Set to something else first to ensure change

        // When
        viewModel.applyPreset(.stable)

        // Then
        XCTAssertEqual(viewModel.preset, .stable)
        XCTAssertEqual(viewModel.dnsHttpsURL, "https://1.1.1.1/dns-query")
        XCTAssertEqual(viewModel.httpsChunkSize, 1)
        XCTAssertTrue(viewModel.httpsDisorder)
        XCTAssertEqual(viewModel.appLaunchDelay, 0)
    }

    func testApplyPresetBalanced() {
        // Given
        viewModel.applyPreset(.custom) // Set to something else first to ensure change

        // When
        viewModel.applyPreset(.balanced)

        // Then
        XCTAssertEqual(viewModel.preset, .balanced)
        XCTAssertEqual(viewModel.dnsHttpsURL, "https://1.1.1.1/dns-query")
        XCTAssertEqual(viewModel.httpsChunkSize, 2)
        XCTAssertTrue(viewModel.httpsDisorder)
        XCTAssertEqual(viewModel.appLaunchDelay, 0)
    }

    func testApplyPresetFast() {
        // Given
        viewModel.applyPreset(.custom) // Set to something else first to ensure change

        // When
        viewModel.applyPreset(.fast)

        // Then
        XCTAssertEqual(viewModel.preset, .fast)
        XCTAssertEqual(viewModel.dnsHttpsURL, "https://1.1.1.1/dns-query")
        XCTAssertEqual(viewModel.httpsChunkSize, 4)
        XCTAssertFalse(viewModel.httpsDisorder)
        XCTAssertEqual(viewModel.appLaunchDelay, 0)
    }

    func testApplyPresetCustom() {
        // Given
        viewModel.applyPreset(.stable)

        // Modify some values manually
        viewModel.setChunkSize(10)
        viewModel.setHTTPSDisorder(false)
        viewModel.setLaunchDelay(5)

        // When
        viewModel.applyPreset(.custom)

        // Then
        XCTAssertEqual(viewModel.preset, .custom)
        // Values shouldn't have changed to stable/balanced/fast defaults
        XCTAssertEqual(viewModel.httpsChunkSize, 10)
        XCTAssertFalse(viewModel.httpsDisorder)
        XCTAssertEqual(viewModel.appLaunchDelay, 5)
    }
}
