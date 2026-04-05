import XCTest
@testable import SpoofTrap

@MainActor
final class BypassViewModelTests: XCTestCase {
    var viewModel: BypassViewModel!

    override func setUp() {
        super.setUp()
        // Initialize the view model
        viewModel = BypassViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testApplyStablePreset() {
        // Arrange & Act
        viewModel.applyPreset(.stable)

        // Assert
        XCTAssertEqual(viewModel.preset, .stable)
        XCTAssertEqual(viewModel.dnsHttpsURL, "https://1.1.1.1/dns-query")
        XCTAssertEqual(viewModel.httpsChunkSize, 1)
        XCTAssertEqual(viewModel.httpsDisorder, true)
        XCTAssertEqual(viewModel.appLaunchDelay, 0)
    }

    func testApplyBalancedPreset() {
        // Arrange & Act
        viewModel.applyPreset(.balanced)

        // Assert
        XCTAssertEqual(viewModel.preset, .balanced)
        XCTAssertEqual(viewModel.dnsHttpsURL, "https://1.1.1.1/dns-query")
        XCTAssertEqual(viewModel.httpsChunkSize, 2)
        XCTAssertEqual(viewModel.httpsDisorder, true)
        XCTAssertEqual(viewModel.appLaunchDelay, 0)
    }

    func testApplyFastPreset() {
        // Arrange & Act
        viewModel.applyPreset(.fast)

        // Assert
        XCTAssertEqual(viewModel.preset, .fast)
        XCTAssertEqual(viewModel.dnsHttpsURL, "https://1.1.1.1/dns-query")
        XCTAssertEqual(viewModel.httpsChunkSize, 4)
        XCTAssertEqual(viewModel.httpsDisorder, false)
        XCTAssertEqual(viewModel.appLaunchDelay, 0)
    }

    func testApplyCustomPreset() {
        // Arrange
        viewModel.applyPreset(.stable) // Set initial state
        let initialDNS = viewModel.dnsHttpsURL
        let initialChunkSize = viewModel.httpsChunkSize
        let initialDisorder = viewModel.httpsDisorder
        let initialLaunchDelay = viewModel.appLaunchDelay

        // Act
        viewModel.applyPreset(.custom)

        // Assert
        XCTAssertEqual(viewModel.preset, .custom)
        // Values should remain unchanged from the previous preset
        XCTAssertEqual(viewModel.dnsHttpsURL, initialDNS)
        XCTAssertEqual(viewModel.httpsChunkSize, initialChunkSize)
        XCTAssertEqual(viewModel.httpsDisorder, initialDisorder)
        XCTAssertEqual(viewModel.appLaunchDelay, initialLaunchDelay)
    }
}
