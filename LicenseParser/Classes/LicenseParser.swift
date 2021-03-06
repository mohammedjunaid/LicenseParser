//
//  LicenseParser.swift
//  Pods
//
//  Created by Clayton Lengel-Zigich on 5/13/16.
//
//

import Foundation
import CrossroadRegex

public class Parser{
  var data: String
  var fieldParser: FieldParsing
  
  public init(data: String){
    self.data = data
    self.fieldParser = FieldParser(data: data)
  }
  
  public func parse() -> ParsedLicense{
    self.fieldParser = versionBasedFieldParsing(parseVersion())

    return License(
      firstName               : fieldParser.parseString("firstName"),
      lastName                : fieldParser.parseString("lastName"),
      middleName              : fieldParser.parseString("middleName"),
      expirationDate          : fieldParser.parseExpirationDate(),
      issueDate               : fieldParser.parseIssueDate(),
      dateOfBirth             : fieldParser.parseDateOfBirth(),
      gender                  : fieldParser.parseGender(),
      eyeColor                : fieldParser.parseEyeColor(),
      height                  : fieldParser.parseHeight(),
      streetAddress           : fieldParser.parseString("streetAddress"),
      city                    : fieldParser.parseString("city"),
      state                   : fieldParser.parseString("state"),
      postalCode              : fieldParser.parseString("postalCode"),
      customerId              : fieldParser.parseString("customerId"),
      documentId              : fieldParser.parseString("documentId"),
      country                 : fieldParser.parseCountry(),
      middleNameTruncation    : fieldParser.parseTruncationStatus("middleNameTruncation"),
      firstNameTruncation     : fieldParser.parseTruncationStatus("firstNameTruncation"),
      lastNameTruncation      : fieldParser.parseTruncationStatus("lastNameTruncation"),
      streetAddressSupplement : fieldParser.parseString("streetAddressSupplement"),
      hairColor               : fieldParser.parseHairColor(),
      placeOfBirth            : fieldParser.parseString("placeOfBirth"),
      auditInformation        : fieldParser.parseString("auditInformation"),
      inventoryControlNumber  : fieldParser.parseString("inventoryControlNumber"),
      lastNameAlias           : fieldParser.parseString("lastNameAlias"),
      firstNameAlias          : fieldParser.parseString("firstNameAlias"),
      suffixAlias             : fieldParser.parseString("suffixAlias"),
      suffix                  : fieldParser.parseNameSuffix(),
      version                 : parseVersion()
    )
  }

  private func versionBasedFieldParsing(version: String?) -> FieldParser{
    let defaultParser = FieldParser(data: self.data)

    guard let v = version else { return defaultParser }

    switch v {
    case "01":
      return VersionOneFieldParser(data: self.data)
    case "04":
      return VersionFourFieldParser(data: self.data)
    case "05":
      return VersionFiveFieldParser(data: self.data)
    case "08":
      return VersionEightFieldParser(data: self.data)
    default:
      return defaultParser
    }
  }

  func parseVersion() -> String?{
    guard let regex        = "ANSI [0-9]{6}([0-9]{2}).*\n".r else { return nil }
    guard let match        = regex.findFirst(data) else { return nil }
    guard let matchedGroup = match.group(1) else { return nil }
    guard !matchedGroup.isEmpty else { return nil }

    return matchedGroup.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
  }

}
