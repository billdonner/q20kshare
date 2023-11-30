//
//  File.swift
//  
//
//  Created by bill donner on 6/24/23.
//

import Foundation

public typealias CLEANINGHandler = ((String)->[String])
public typealias ITEMHandler = (ChatContext,String,FileHandle?) throws ->()


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
    let aiopinion = try JSONDecoder().decode(AIOpinion .self,from:item.data(using:.utf8)!)
    opinion =  aiopinion.toOpinion(source: source)
  }
  catch {
    do {
      let aiopinion = try JSONDecoder().decode(AIAltOpinion .self,from:item.data(using:.utf8)!)
      opinion = aiopinion.toOpinion(source: source)
    }
    catch {
      print("*** No opinion found \(error)\n item: '\(item)'")
    }
  }
  return opinion
}

public func standardSubstitutions(source:String,stats:ChatContext)->String {
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


extension Challenge {
  public func makeTruthQuery ( ) -> TruthQuery {
    TruthQuery(id: self.id, question:self.question, answer: self.correct, truth: Truthe.unknownValue)
  }
}

public func getAPIKey() throws -> String {
  var wooky:String = ""
//  let  looky = ProcessInfo.processInfo.environment["OPENAI_API_KEY"]
//  if let looky = looky { wooky = looky }
//  if wooky == "" {
    wooky = "/users/fs/openapi.key"
 // }
  let key = try String(contentsOfFile: wooky,encoding: .utf8)
 return   key.trimmingCharacters(in: .whitespacesAndNewlines)
}
public func  prepOutputChannels(ctx:ChatContext)throws -> FileHandle? {
  func prep(_ x:String, initial:String) throws  -> FileHandle? {
    if (FileManager.default.createFile(atPath: x, contents: nil, attributes: nil)) {
      print(">Pumper created \(x)")
    } else {
      print("\(x) not created."); throw PumpingErrors.badOutputURL
    }
    guard let  newurl = URL(string:x)  else {
      print("\(x) is a bad url"); throw PumpingErrors.badOutputURL
    }
    do {
      let  fh = try FileHandle(forWritingTo: newurl)
      fh.write(initial.data(using: .utf8)!)
      return fh
    } catch {
      print("Cant write to \(newurl), \(error)"); throw PumpingErrors.cantWrite
    }
  }
  guard  ctx.outURL.absoluteString.hasPrefix("file://") else
  {
    throw PumpingErrors.onlyLocalFilesSupported
  }
  let s = String(ctx.outURL.deletingPathExtension().absoluteString.dropFirst(7))
  let x = s + ".json"
  return  try prep(x,initial:"[")
}

func encodeStringForJSON(string: String) -> String {
  let escapedString = string.replacingOccurrences(of: "\"", with: "\\\"")
  return "\"\(escapedString)\""
}

public func dontCallTheAI(ctx:ChatContext, prompt: String) {
  print("\n>Deliberately not calling AI for prompt #\(ctx.tag):\n")
  print(prompt)
  //sleep(3)
}

public func callChatGPT( ctx:ChatContext,
                             prompt:String,
                             outputting: @escaping (String)->Void ,
                              wait:Bool = false ) throws
{
  ctx.prompt = encodeStringForJSON(string:prompt) // copy this away
 var request = URLRequest(url: ctx.apiURL)
 request.httpMethod = "POST"
 request.setValue("application/json", forHTTPHeaderField: "Content-Type")
 request.setValue("Bearer " + ctx.apiKey, forHTTPHeaderField: "Authorization")
 request.timeoutInterval = 240//yikes
 
 var respo:String = ""
 
 let parameters: [String: Any] = [
  
   "model": ctx.model,
   "max_tokens": 2000,
   "top_p": 1,
   "frequency_penalty": 0,
   "presence_penalty": 0,
   "temperature": 1.0,
   "messages" : """
[{  "role": "system",
      "content": "this is the system area"
}
,
{ "role" : \(prompt)
}]
"""
 ]
 request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
 if ctx.verbose {
   print("\n>Prompt #\(ctx.tag): \n\(prompt) \n\n>Awaiting response #\(ctx.tag) from AI.\n")
 }
 else {
   print("\n>Prompt #\(ctx.tag): Awaiting response from AI.\n")
 }
 
 let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
   guard let data = data, error == nil else {
     print("*** Network error communicating with AI ***")
     print(error?.localizedDescription ?? "Unknown error")
     ctx.networkGlitches += 1
     print("*** continuing ***\n")
     respo = " " // a hack to bust out of wait loop below
     return
   }
   do {
     let response = try JSONDecoder().decode(ChatGPTResponse.self, from: data)
     respo  = response.choices.first?.text ?? "<<nothin>>"
     outputting(respo)
   }  catch {
     print ("*** Failed to decode response from AI ***\n",error)
     let str = String(decoding: data, as: UTF8.self)
     print (str)
     ctx.networkGlitches += 1
     print("*** NOT continuing ***\n")
     respo = " " // a hack to bust out of wait loop below
     //return
     exit(0)
   }
 }
 task.resume()
 // linger here if asked to wait
 if wait {
   var cycle = 0
   while true && respo == ""  {
     //print before we sleep
     if ctx.dots {print("\(cycle)",terminator: "")}
     cycle = (cycle+1) % 10
     for _ in 0..<10 {
       if respo != "" { break }
       sleep(1)
     }
 
   }
 }
}

  func handleAIResponse(ctx:ChatContext,cleaned: [String],jsonOut:FileHandle?,
                        itemHandler:ITEMHandler) {
    
    // check to make sure it's valid and write to output file
    for idx in 0..<cleaned.count {
      do {
        try itemHandler(ctx,cleaned [idx],jsonOut )
      }
      catch {
        print(">Pumper Could not decode \(error), \n>*** BAD JSON FOLLOWS ***\n\(cleaned[idx])\n>*** END BAD JSON ***\n")
        ctx.badJsonCount += 1
        print("*** continuing ***\n")
      }
    }
  }
  
  func callTheAI(ctx:ChatContext,
                 prompt: String,
                 jsonOut:FileHandle?,
                 cleaner:@escaping CLEANINGHandler,
                 itemHandler: @escaping ITEMHandler)  {
    // going to call the ai
    let start_time = Date()
    do {
      try callChatGPT(ctx:ctx,
                      prompt : prompt,
                      outputting:  { response in
        // process response from chatgpt
        let cleaned = cleaner(response)
        // if not good then pumpCount not incremented
        if cleaned.count == 0 {
          print("\n>AI Response #\(ctx.tag): no challenges  \n")
          return
        }
        handleAIResponse(ctx:ctx, cleaned:cleaned, jsonOut:jsonOut){ ctx,s,fh  in
          try itemHandler(ctx,s,fh )
        }
        
        ctx.pumpCount += cleaned.count  // this is the number items from 
        let elapsed = Date().timeIntervalSince(start_time)
        print("\n>AI Response #\(ctx.tag): \(cleaned.count) challenges returned in \(elapsed) secs\n")
        if ctx.pumpCount >= ctx.max {  // so max limits the number of times we will successfully call chatgpt
         return // Pumper.exit()
        }
      }, wait:true)
      // did not throw
    } catch {
      // if callChapGPT throws we end up here and just print a message and continu3
      let elapsed = Date().timeIntervalSince(start_time)
      print("\n>AI Response #\(ctx.tag): ***ERROR \(error) no challenges returned in \(elapsed) secs\n")
    }
  }
public func pumpItUp(ctx:ChatContext,
                     templates: [String],
                     jsonOut:FileHandle,
                     justOnce:Bool,
                     cleaner:@escaping CLEANINGHandler,
                     itemHandler:@escaping ITEMHandler) throws {
  
  while ctx.pumpCount<ctx.max {
    // keep doing until we hit user defined limit
    for (idx,t) in templates.enumerated() {
      guard ctx.pumpCount < ctx.max else { throw PumpingErrors.reachedMaxLimit }
      let prompt0 = stripComments(source: String(t), commentStart: ctx.comments_pattern)
      if t.count > 0 {
        let prompt = standardSubstitutions(source:prompt0,stats:ctx)
        if prompt.count > 0 {
          ctx.global_index += 1
          ctx.tag = String(format:"%03d",ctx.global_index) +  "-\(ctx.pumpCount)" + "-\( ctx.badJsonCount)" + "-\(ctx.networkGlitches)"
          if ctx.dontcall {
            dontCallTheAI(ctx:ctx, prompt: prompt)
          } else {
            callTheAI(ctx: ctx, prompt: prompt,jsonOut:jsonOut, cleaner:cleaner,itemHandler: itemHandler)
          }
        }
      } else {
        print("Warning - empty template #\(idx)")
      }
    }// for
    if justOnce { throw PumpingErrors.reachedEndOfScript}
  }
  throw PumpingErrors.reachedMaxLimit
}
