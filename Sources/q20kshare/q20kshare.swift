import Foundation
public struct q20kshare {
    public private(set) var text = "Q20KSHARE"
    public private(set) var version = "0.2"
    public init() {
    }
}

/* Challenge(s) is the basic heart of q20k world */

public struct AIReturns: Codable {
  public let question: String
  public let topic: String
  public let hint:String // a hint to show if the user needs help
  public let answers: [String]
  public let correct: String // which answer is correct
  public let explanation: String? // reasoning behind the correctAnswer
  public let article: String?// URL of article about the correct Answer
  public let image:String? // URL of image of correct Answer

   public func toChallenge() -> Challenge {
      Challenge(question: self.question, topic: self.topic, hint:self.hint, answers:self.answers, correct: self.correct,id:UUID().uuidString,date:Date())
  }
}
public struct Challenge : Codable,Equatable,Hashable  {
  internal init(question: String, topic: String, hint: String, answers: [String], correct: String, explanation: String? = nil, article: String? = nil, image: String? = nil, id: String? = nil, date: Date? = nil) {
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
  }
  

  
  public let question: String
  public let topic: String
  public let hint:String // a hint to show if the user needs help
  public let answers: [String]
  public let correct: String // which answer is correct
  public let explanation: String? // reasoning behind the correctAnswer
  public let article: String?// URL of article about the correct Answer
  public let image:String? // URL of image of correct Answer
  // these fields are hidden from the ai and filled in by prepper
  public let id:String? // can be real uuid
  public let date:Date? // hmmm
  
  
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
