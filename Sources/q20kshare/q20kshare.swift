import Foundation
public struct q20kshare {
  public private(set) var text = "Q20KSHARE"
  public private(set) var version = "0.2.3"
  public init() {
  }
}

/* Challenge(s) is the basic heart of q20k world */

public struct AIReturns: Codable,Equatable,Hashable {
  public init(question: String, topic: String, hint: String, answers: [String], correct: String, source:String, explanation: String? = nil, article: String? = nil, image: String? = nil) {
    self.question = question
    self.topic = topic
    self.hint = hint
    self.answers = answers
    self.correct = correct
    self.explanation = explanation
    self.article = article
    self.image = image
  }
  
  public let question: String
  public let topic: String
  public let hint:String // a hint to show if the user needs help
  public let answers: [String]
  public let correct: String // which answer is correct
  public let explanation: String? // reasoning behind the correctAnswer
  public let article: String?// URL of article about the correct Answer
  public let image:String? // URL of image of correct Answer
  
  public func toChallenge(source:String) -> Challenge {
    Challenge(question: self.question, topic: self.topic, hint:self.hint, answers:self.answers, correct: self.correct,id:UUID().uuidString,date:Date(),source:source)
  }
}
public struct Challenge : Codable,Equatable,Hashable  {
  public init(question: String, topic: String, hint: String, answers: [String],
              correct: String, explanation: String? = nil, article: String? = nil, image: String? = nil, id: String = "", date: Date = Date(),source: String = "", prompt:String = "", opinions:[Opinion] = []) {
    self.question = question
    self.topic = topic
    self.hint = hint
    self.answers = answers
    self.correct = correct
    self.explanation = explanation
    self.article = article
    self.image = image
    self.id = id
    self.date = date
    self.source = source
    self.prompt = prompt
    self.opinions = opinions
  }
  
  public let question: String
  public let topic: String
  public let hint:String // a hint to show if the user needs help
  public let answers: [String]
  public let correct: String // which answer is correct
  public let explanation: String? // reasoning behind the correctAnswer
  public let article: String?// URL of article about the correct Answer
  public let image:String? // URL of image of correct Answer
  // these fields are hidden from the ai and filled in by pumper
  public let id:String // can be real uuid
  public let date:Date // hmmm
  public let source:String
  public let prompt:String
  public let opinions:[Opinion]
  
  
  public static func decodeArrayFrom(data:Data) throws -> [Challenge]{
    try JSONDecoder().decode([Challenge].self, from: data)
  }
  public static func decodeFrom(data:Data) throws -> Challenge {
    try JSONDecoder().decode( Challenge.self, from: data)
  }
  
}
/* an array of GameData is published to the IOS App */

public struct GameData : Codable, Hashable,Identifiable,Equatable {
  public  init(subject: String, challenges: [Challenge]) {
    self.subject = subject
    self.challenges = challenges //.shuffled()  //randomize
    self.id = UUID().uuidString
    self.generated = Date()
  }
  
  public   let id : String
  public   let subject: String
  public   let challenges: [Challenge]
  public   let generated: Date
}

/** Opinions arrive from multiple ChatBots */
public struct AIOpinion: Codable,Equatable,Hashable,Identifiable {
  public let id:String
  public let truth:Bool
  public let explanation:String
  
  public func toOpinion(source:String) -> Opinion{
    Opinion(id:UUID().uuidString,truth:truth,explanation: explanation,source:source)
  }
}
public struct AIAltOpinion: Codable,Equatable,Hashable,Identifiable {
  public let id:String
  public let truth:String
  public let explanation:String
  
  public func toOpinion(source:String) -> Opinion?{
    let t = truth.lowercased()
    let q = Bool(t)
    if let q = q {
      return   Opinion(id:UUID().uuidString,truth:q,explanation: explanation,source:source)
    }
    return nil
  }
}
public struct Opinion : Codable, Equatable, Hashable,Identifiable {
  public  init(id: String, truth: Bool, explanation: String, source: String) {
    self.id = id
    self.truth = truth
    self.source = source
    self.explanation = explanation
    self.generated = Date()
  }
  
  public let id:String
  public let truth:Bool
  public let explanation:String
  public let source:String
  public let generated:Date
  
}
public struct ChatGPTChoice: Codable {
  public  let text: String
}

public struct ChatGPTResponse: Codable {
  public let choices: [ChatGPTChoice]
}


public class ChatContext {
  public init(max: Int = 1, apiKey: String, apiURL: URL, outURL:URL,model: String , verbose: Bool , dots: Bool, dontcall:Bool,comments_pattern:String,split_pattern:String, style:PumpStyle ) {
    self.max = max
    self.apiKey = apiKey
    self.apiURL = apiURL
    self.outURL = outURL
    self.model = model
    self.dots = dots
    self.verbose = verbose
    self.dontcall = dontcall
    self.comments_pattern = comments_pattern
    self.split_pattern = split_pattern
    self.style = style
  }
  
  public var apiKey:String
  public var apiURL: URL
  public var outURL: URL
  public var model: String
  public var verbose: Bool
  public var dots:Bool
  public var dontcall:Bool
  public var comments_pattern:String
  public var split_pattern:String 
  public var style:PumpStyle
  
  public var tag = ""
  public var first = true
  public var max = 1
  public var global_index = 0
  public var pumpCount = 0
  public var badJsonCount = 0
  public var networkGlitches = 0
  
}
public enum PumpStyle {
  case promptor
  case validator
}


public enum PumpingErrors: Error {
  case badInputURL
  case badOutputURL
  case cantWrite
  case noAPIKey
  case onlyLocalFilesSupported
  case reachedMaxLimit
  case reachedEndOfScript
}
public protocol ChatBotInterface {
  func callTheAI(ctx:ChatContext,prompt: String,jsonOut:FileHandle?  ) throws
  func handleAIResponse(ctx:ChatContext, cleaned: [String],jsonOut:FileHandle?)
  func pumpItUp(ctx:ChatContext, templates: [String],jsonOut:FileHandle) throws
}
public struct TruthQuery :Codable {
  let id:String
  let question:String
  let answer:String
  let truth:Bool?
}
extension Challenge {
  public func makeTruthQuery ( ) -> TruthQuery {
    TruthQuery(id: self.id, question:self.question, answer: self.correct, truth: nil)
  }
}
public func getAPIKey() throws -> String {
  let  looky = ProcessInfo.processInfo.environment["OPENAI_API_KEY"]
  guard let looky=looky  else { throw PumpingErrors.noAPIKey }
  // the key is now stored in there
  
  let key = try String(contentsOfFile: looky,encoding: .utf8)
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
