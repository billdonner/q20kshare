
PHASE I BEGINS

STEP ONE: FIRST WE RUN PUMPER WITH PUMPER SCHEME
  .....

>Awaiting response #104-103-0-0 from AI.

01
>AI Response #104-103-0-0: 1/5 challenges returned in 27.611078023910522 secs

2
>Prompt #105-104-0-0:
here is JSON block for a question and answer game about Presidents:
{
  "topic": "Presidents",
  "theme": "Famous Men",
  "question": "Who was the first president of the United States?",
  "answers": ["Thomas Jefferson", "George Washington", "John Adams"],
  "correct": "George Washington",
  "hint":"He Chopped Down a Cherry Tree",
  "explanation": "General Washington led the Americans against the British before being elected President"
}
Generate a JSON array of 5 blocks with a topic of "Dogs" with a theme of "Man's Best Friend"
make the questions and explanations fun and witty
use double quotes except within field values, where single quotes should be utilized
do not generate a comma after the last field value within the block
ensure each member of the "answers" array is surrounded by double quotes
ensure every generated block is valid JSON
[{
  
  >Awaiting response #105-104-0-0 from AI.
  
  0Program ended with exit code: 9
  
  
  
  STEP TWO  NOW WE RUN PREPPER WITH THE PUMPER OUTPUT
  
  
  >Prepper Command Line: ["/Users/billdonner/Library/Developer/Xcode/DerivedData/prepper-gogzbrmrpumxoscjtnkmwchswzsw/Build/Products/Debug/prepper", "file:///users/billdonner/Desktop/fs/prepper-main-out", "file:///users/billdonner/Desktop/fs/prepper-main-in.json"]
  >Prepper running at 2023-06-20 10:26:56 +0000
  ****Trying to recover from decoding error, dataCorrupted(Swift.DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid JSON.", underlyingError: Optional(Error Domain=NSCocoaErrorDomain Code=3840 "Unexpected end of file around line 7812, column 1." UserInfo={NSDebugDescription=Unexpected end of file around line 7812, column 1., NSJSONSerializationErrorIndex=186661})))
  >Read file:///users/billdonner/Desktop/fs/prepper-main-in.json - 0 bytes, 519 challenges
  Topic - Cats, 65 challenges
  Topic - Politicians, 65 challenges
  Topic - Grifters, 65 challenges
  Topic - New York Yankees, 65 challenges
  Topic - Dogs, 65 challenges
  Topic - Imposters, 65 challenges
  Topic - Baseball, 64 challenges
  Topic - Amphibians, 65 challenges
  Duplicate Question - Who was the first female Prime Minister of India?, 2 dupe
  Duplicate Question - Who is the current Chancellor of Germany?, 1 dupe
  Duplicate Question - What is the smallest breed of dog?, 1 dupe
  Duplicate Question - How many bases are there in baseball?, 1 dupe
  Duplicate Question - What is the smallest breed of dog in the world?, 1 dupe
  Duplicate Question - What is a group of frogs called?, 1 dupe
  ****Trying to recover from decoding error, dataCorrupted(Swift.DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid JSON.", underlyingError: Optional(Error Domain=NSCocoaErrorDomain Code=3840 "Unexpected end of file around line 7812, column 1." UserInfo={NSDebugDescription=Unexpected end of file around line 7812, column 1., NSJSONSerializationErrorIndex=186661})))
  >Prepper reading from file:///users/billdonner/Desktop/fs/prepper-main-in.json
  >Prepper created /users/billdonner/Desktop/fs/prepper-main-out-prompts.txt
  >Wrote 116496 bytes 519 prompts to file:///users/billdonner/Desktop/fs/prepper-main-out-prompts.txt
  >Wrote 217088 bytes, 519 challenges, 8 topics to file:///users/billdonner/Desktop/fs/prepper-main-out-gamedata.json in elapsed 0.03132903575897217 secs
  >Prepper finished in 0.09709501266479492secs
  Program ended with exit code: 0
  
  
  BEGIN PHASE II
  
  STEP THREE: RUNNING PUMPER USING 'VERSAPUMP' SCHEME
  
  >Prompt #021-20-0-0:
  {
    "id" : "BBC375F9-E187-450B-A0C1-1AEF33003CAE",
    "question" : "Which animal can live completely in the water, completely on land, or both?",
    "answer" : "Newts"
  }
  Answer with id ,truth, and multi-line explanation as JSON
  
  >Awaiting response #021-20-0-0 from AI.
  
  
  >AI Response #021-20-0-0: 1/1 challenges returned in 6.212952017784119 secs
  
  0
  >Prompt #022-21-0-0:
  {
    "id" : "2525B5F9-C2C3-4602-8DAD-01B11EDCD682",
    "question" : "What is a toad's superpower?",
    "answer" : "Invisibility"
  }
  Answer with id ,truth, and multi-line explanation as JSON
  
  >Awaiting response #022-21-0-0 from AI.
  
  ... accumulating 500 +
  
  actually got many fewer
  
  STEP FOUR:  NOW RUN 'BLENDER' TO INTEGRATE OPINIONS
  
  >Blender Command Line: ["/Users/billdonner/Library/Developer/Xcode/DerivedData/Blender-enraaijvlfayyoevimhxjshbolcm/Build/Products/Debug/Blender", "/users/billdonner/Desktop/fs/prepper-main-in.json", "/users/billdonner/Desktop/fs/prepper-veracity-in.json", "-o", "/users/billdonner/Desktop/fs/blender-output.json"]
  >Blender running at 2023-06-20 11:59:30 +0000
  ****Trying to recover from Challenge decoding error, dataCorrupted(Swift.DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid JSON.", underlyingError: Optional(Error Domain=NSCocoaErrorDomain Code=3840 "Unexpected end of file around line 7812, column 1." UserInfo={NSDebugDescription=Unexpected end of file around line 7812, column 1., NSJSONSerializationErrorIndex=186661})))
  ****Fixed by adding trailing ], there is nothing to do
    >Blender: 519 Challenges
    ****Trying to recover from Opinion decoding error, dataCorrupted(Swift.DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid JSON.", underlyingError: Optional(Error Domain=NSCocoaErrorDomain Code=3840 "Unexpected end of file around line 1573, column 1." UserInfo={NSDebugDescription=Unexpected end of file around line 1573, column 1., NSJSONSerializationErrorIndex=126802})))
    ****Fixed by adding trailing ], there is nothing to do
      >Blender: 262 Opinions
      >Blender: 262 Merged
      >Blender finished in 0.11355698108673096secs
      Program ended with exit code: 0
      
      
      
      STEP FIVE: NOW RUN PREPPER WITH SCHEME 'BLENDED'
      
      >Prepper Command Line: ["/Users/billdonner/Library/Developer/Xcode/DerivedData/prepper-gogzbrmrpumxoscjtnkmwchswzsw/Build/Products/Debug/prepper", "file:///users/billdonner/Desktop/fs/readyforios2", "file:///users/billdonner/Desktop/fs/blender-output.json"]
      >Prepper running at 2023-06-20 11:53:07 +0000
      >Read file:///users/billdonner/Desktop/fs/blender-output.json - 0 bytes, 262 challenges
      Topic - Cats, 59 challenges
      Topic - Grifters, 41 challenges
      Topic - Baseball, 52 challenges
      Topic - Amphibians, 57 challenges
      Topic - Dogs, 53 challenges
      Duplicate Question - What is the smallest breed of dog?, 1 dupe
      Duplicate Question - How many bases are there in baseball?, 1 dupe
      >Prepper reading from file:///users/billdonner/Desktop/fs/blender-output.json
      >Prepper created /users/billdonner/Desktop/fs/readyforios2-prompts.txt
      >Wrote 57115 bytes 262 prompts to file:///users/billdonner/Desktop/fs/readyforios2-prompts.txt
      >Wrote 106510 bytes, 262 challenges, 5 topics to file:///users/billdonner/Desktop/fs/readyforios2-gamedata.json in elapsed 0.013641953468322754 secs
      >Prepper finished in 0.05494701862335205secs
      Program ended with exit code: 0
      
      STEP 6: Now we have "READYFORIOS2"
      
      run the QANDA app :)
      
