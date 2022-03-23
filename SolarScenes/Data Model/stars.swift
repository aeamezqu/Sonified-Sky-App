/// Copyright (c) 2022 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

struct stars_coordinates {
  var ra: String = ""
  var dec: String = ""
  var type: String = ""
  var const: String = ""
  var mag: String = ""
  var name: String = ""
  var rarad: String = ""
  var decrad: String = ""
  var id: String = ""
  var r1: String = ""
  var r2: String = ""
  var angle: String = ""
  var dsoSource: String = ""
  var id1: String = ""
  var cat1: String = ""
  var id2: String = ""
  var cat2: String = ""
  var dupid: String = ""
  var dupcat: String = ""
  var displayMag: String = ""
  
  init(raw: [String]) {
    ra = raw[0]
    dec = raw[1]
    type = raw[2]
    const = raw[3]
    mag = raw[4]
    name = raw[5]
    rarad = raw[6]
    decrad = raw[7]
  }
  
}

func loadCSV(from csvName: String) -> [stars_coordinates] {
  var csvToStruct = [stars_coordinates]()
  
  // locate csv file
  guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
    return[]
  }
  
  //convert the contents of the file into one long string
  var data = ""
  do {
    data = try  String(contentsOfFile: filePath)
  } catch {
    print(error)
    return[]
  }
  
 //split the long string into an array of "rows" of data. Each row is a string
 //detect "/n" carriage return, then split
  var rows = data.components(separatedBy: "\n")
  
  //remove hedeaer rows
  rows.removeFirst()
  
  //now loop around each row and split into columns
  for row in rows {
    let csvColumns = row.components(separatedBy: ",")
    let stars_coordinatesStruct = stars_coordinates.init(raw: csvColumns)
    csvToStruct.append(stars_coordinatesStruct)
  }
  
  return csvToStruct
  
}
