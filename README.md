# q20kshare

Freeport.Software 0.0.13

shared data structures and code for q20k family

We are building a pipeline of sequential batch processing steps. The input is Scripts, which are just text files of Prompts which are fed to the Chatbots. The output , many steps later, is JSON in GameData format, ready to play in our IOS app.

To make a Script you can just use any old text editor to write a prompt for chatbot. You can put many prompts into a script by inserting three stars to separate them. All the scripts will get serviced in order.

You can also make a Script using the Sparky Utility. It is a macro processor that works off templates and parameter lists to allow the user to generate a whole set of similar prompts in a single script. 

Once we have a Script, the pipeline begins.
Step 0: Make a script with Sparky, or by other means

Step 1: Pumper executes the script, sending each prompt to the ChatBot and generating a single output file of JSON Challenges which is read by Prepper and, in a later step, by Blender

Step 2: Prepper reads the JSON Challenges from Pumper de-duplicates, and prepares a new script. This script contains questions about the veracity of the JSON data and is read by Veracitator.

Step 3: Veracitator executes script file, sending each prompt to (another) Chatbot and generates a single output file of JSON data which is read by Blender.

Step 4: Blender merges the data from Veracitator with the Prepper  and prepares a single output file ReadyforIOS.

Each step has but one input, and one output. The names of these files are :
- Between_0_1.txt
- Between_1_2.json
- Between_2_3.txt
- Between_3_4.json
- Blender takes Between_1_2.json and Between_3_4.json and blends them into ReadyForIOSx.json

We are striving to get the whole thing running with or without human intervention.

Parameters for all these commands will change a bit.
