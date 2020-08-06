//
//  String+Version.swift
//  Pods
//
//  Created by DragonCherry on 5/11/17.


import Foundation

//extension String {
//     ///https://github.com/DragonCherry/VersionCompare
//    /// Inner comparison utility to handle same versions with different length. (Ex: "1.0.0" & "1.0")
//    private func compare(toVersion targetVersion: String) -> ComparisonResult {
//
//        let versionDelimiter = "."
//        var result: ComparisonResult = .orderedSame
//        var versionComponents = components(separatedBy: versionDelimiter)
//        var targetComponents = targetVersion.components(separatedBy: versionDelimiter)
//        let spareCount = versionComponents.count - targetComponents.count
//
//        if spareCount == 0 {
//            result = compare(targetVersion, options: .numeric)
//        } else {
//            let spareZeros = repeatElement("0", count: abs(spareCount))
//            if spareCount > 0 {
//                targetComponents.append(contentsOf: spareZeros)
//            } else {
//                versionComponents.append(contentsOf: spareZeros)
//            }
//            result = versionComponents.joined(separator: versionDelimiter)
//                .compare(targetComponents.joined(separator: versionDelimiter), options: .numeric)
//        }
//        return result
//    }
//
//    public func isVersion(equalTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedSame }
//    public func isVersion(greaterThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedDescending }
//    public func isVersion(greaterThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedAscending }
//    public func isVersion(lessThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedAscending }
//    public func isVersion(lessThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedDescending }
//}


extension String {
//  func getRawVersionString() -> String? {
//    return (self.removePrefix("v") as AnyObject)
//          .split(separator: "-")
//        .first.toString()
//  }

  // Modified from the DragonCherry extension - https://github.com/DragonCherry/VersionCompare
  //https://gist.github.com/endy-s/3791fe5c856cccaabff331fd49356dbf
  //https://gist.github.com/endy-s/7cacaa730bf9fd5abf6021e58e962191
    
  private func compare(toVersion targetVersion: String) -> ComparisonResult {
      let versionDelimiter = "."
      var result: ComparisonResult = .orderedSame
      var versionComponents = components(separatedBy: versionDelimiter)
      var targetComponents = targetVersion.components(separatedBy: versionDelimiter)

      while versionComponents.count < targetComponents.count {
          versionComponents.append("0")
      }
      while targetComponents.count < versionComponents.count {
          targetComponents.append("0")
      }

      for (version, target) in zip(versionComponents, targetComponents) {
          result = version.compare(target, options: .numeric)
          if result != .orderedSame {
              break
          }
      }

      return result
  }

  func isVersion(equalTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedSame }
  func isVersion(greaterThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedDescending }
  func isVersion(greaterThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedAscending }
  func isVersion(lessThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedAscending }
  func isVersion(lessThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedDescending }
}



//class StringTests: XCTestCase {
//
//    func testParseVersions() {
//        XCTAssertTrue("2.2.100-alpha".getRawVersionString()?.isVersion(lessThan:
//            "v2.3.2".getRawVersionString() ?? "0") ?? false)
//        XCTAssertTrue("v2.2.13".getRawVersionString()?.isVersion(lessThan:
//                "v2.4.16-37-geea723b-merck-blackhawk".getRawVersionString() ?? "0") ?? false)
//        XCTAssertTrue("v2.4.21-alpha".getRawVersionString()?.isVersion(lessThan:
//            "v2.4.22-103-g2f56154-trunk".getRawVersionString() ?? "0") ?? false)
//        XCTAssertTrue("v2.5.1-53-gded80545-dirty-jacob-uglydb".getRawVersionString()?.isVersion(lessThan:
//            "v2.5.6-alpha".getRawVersionString() ?? "0") ?? false)
//        XCTAssertTrue("v2.5.6-alpha".getRawVersionString()?.isVersion(equalTo:
//            "v2.5.6-beta".getRawVersionString() ?? "0") ?? false)
//        XCTAssertTrue("v2.5.9-12-gbab374f-brad-trigger-hw-test".getRawVersionString()?.isVersion(lessThan:
//            "v2.6.10-alpha".getRawVersionString() ?? "0") ?? false)
//        XCTAssertTrue("v2.6.10-alpha".getRawVersionString()?.isVersion(equalTo:
//            "v2.6.10-beta".getRawVersionString() ?? "0") ?? false)
//        XCTAssertTrue("v2.6.10-beta".getRawVersionString()?.isVersion(lessThan:
//            "v2.6.12-1-gf1eaeee-alpha".getRawVersionString() ?? "0") ?? false)
//        XCTAssertTrue("v2.6.12-3-gde72d3db-trunk".getRawVersionString()?.isVersion(equalTo:
//            "v2.6.12-beta".getRawVersionString() ?? "0") ?? false)
//        XCTAssertTrue("v2.6.3".getRawVersionString()?.isVersion(lessThan:
//            "v2.6.5-trunk".getRawVersionString() ?? "0") ?? false)
//        XCTAssertTrue("v2.6.7-beta".getRawVersionString()?.isVersion(equalTo:
//            "v2.6.7-dirty-a759b3e9".getRawVersionString() ?? "0") ?? false)
//        XCTAssertTrue("v2.6.8-alpha".getRawVersionString()?.isVersion(lessThan:
//            "v2.6.9-3-g313942c-jacob-rehashes".getRawVersionString() ?? "0") ?? false)
//        XCTAssertTrue("v2.6.9-alpha".getRawVersionString()?.isVersion(lessThan:
//            "2.6.10".getRawVersionString() ?? "0") ?? false)
//    }
//
//    func testStringVersionExtension() {
//        // Test cases created by DragonChery - https://stackoverflow.com/a/44361022/7806488
//        XCTAssertTrue(UIDevice.current.systemVersion.isVersion(lessThan: "99.0.0"))
//        XCTAssertTrue(UIDevice.current.systemVersion.isVersion(equalTo: UIDevice.current.systemVersion))
//        XCTAssertTrue(UIDevice.current.systemVersion.isVersion(greaterThan: "3.5.99"))
//        XCTAssertTrue(UIDevice.current.systemVersion.isVersion(lessThanOrEqualTo: "13.5.99"))
//        XCTAssertTrue(UIDevice.current.systemVersion.isVersion(greaterThanOrEqualTo: UIDevice.current.systemVersion))
//        XCTAssertTrue("0.1.1".isVersion(greaterThan: "0.1"))
//        XCTAssertTrue("0.1.0".isVersion(equalTo: "0.1"))
//        XCTAssertTrue("10.0.0".isVersion(equalTo: "10"))
//        XCTAssertTrue("10.0.1".isVersion(equalTo: "10.0.1"))
//        XCTAssertTrue("5.10.10".isVersion(lessThan: "5.11.5"))
//        XCTAssertTrue("1.0.0".isVersion(greaterThan: "0.99.100"))
//        XCTAssertTrue("0.5.3".isVersion(lessThanOrEqualTo: "1.0.0"))
//        XCTAssertTrue("0.5.29".isVersion(greaterThanOrEqualTo: "0.5.3"))
//        // Test cases created by Endy after improving the extension
//        XCTAssertTrue("10.0.1.2".isVersion(equalTo: "10.0.1.2"))
//        XCTAssertTrue("5.10.10.1.3".isVersion(lessThan: "5.11.5"))
//        XCTAssertTrue("1.0.0.9".isVersion(greaterThan: "0.99.100"))
//        XCTAssertTrue("0.5.3.99".isVersion(lessThanOrEqualTo: "1.0.0"))
//        XCTAssertTrue("0.5.29.1".isVersion(greaterThanOrEqualTo: "0.5.3"))
//    }
//}
