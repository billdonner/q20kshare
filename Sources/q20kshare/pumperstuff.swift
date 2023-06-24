//
//  File.swift
//  
//
//  Created by bill donner on 6/24/23.
//

import Foundation


//write swift function to return substring of a string between a start delimeter and end delimeter.
//include comments

/*
 This function takes a string and two delimiters as arguments.
 It will return the substring which begins after the first delimiter and ends before the second one.
   -Parameter str: The original string which is to be searched
   -Parameter startDelim: The substring that is beginning of the substring to be extracted
   -Parameter endDelim: The substring that is the end of the substring to be extracted
   -Returns: A substring beginning after startDelim and ending before endDelim
*/
public func extractSubstring(str: String, startDelim: String, endDelim: String) -> String {
    if !str.contains(startDelim) || !str.contains(endDelim) { return "" }
    
    let start = str.firstIndex(of: startDelim.first!)!
    let end = str.firstIndex(of: endDelim.first!)!

    return String(str[start...end])
}
public  func getOpinion(_ xitem:String,source:String) throws -> Opinion? {
  let item = extractSubstring(str: xitem, startDelim: "{", endDelim: "}")
  guard item != "" else { print("** nothing found in getOpinion from \(xitem)"); return nil }
  var opinion:Opinion? = nil
  do {
    opinion = try JSONDecoder().decode(AIOpinion .self,from:item.data(using:.utf8)!).toOpinion(source: source)
  }
  catch {
    do {
      opinion = try JSONDecoder().decode(AIAltOpinion .self,from:item.data(using:.utf8)!).toOpinion(source: source)
    }
    catch {
      print("*** No opinion found \(error)\n item: '\(item)'")
    }
  }
  return opinion
}

public func standardSubstitutions(source:String,stats:AINetStats)->String {
  let source0 = source.replacingOccurrences(of:"$INDEX", with: "\(stats.global_index)")
  let source1 = source0.replacingOccurrences(of:"$NOW", with: "\(Date())")
  let source2 = source1.replacingOccurrences(of: "$UUID", with: UUID().uuidString)
  return source2
}

public func extractSubstringsInBrackets(input: String) -> [String] {
  var matches: [String] = []
  var completed: [Bool] = []
  var idx = 0 // into matches
  var inside = false
  matches.append("")
  completed.append(false)
  for c in input {
    switch c {
    case "{":
      if inside { continue }//fatalError("already inside")}
      inside = true
      matches [idx].append("{")
      completed [idx] =  false
    case "}":
      if !inside {  continue }//fatalError("not inside")}
      inside = false
      matches [idx].append("}")
      completed [idx] = true
      idx += 1
      matches.append("")
      completed.append(false)
    default: if inside {
      matches [idx].append(c)
    }
   }
  }
  if !completed[idx] {
    matches.removeLast()
  }
  return matches.filter {
    $0 != ""
  }
}
 
public func stripComments(source: String, commentStart: String) -> String {
  let lines = source.split(separator: "\n")
  var keeplines:[String] = []
  for line in lines  {
    if !line.hasPrefix(commentStart) {
      keeplines += [String(line)]
    }
  }
  return keeplines.joined(separator: "\n")
}

