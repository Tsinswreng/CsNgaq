// pandoc README.typ -o README.md
= CsNgaq

An app helps you remember vocabularies

Tech Stack:
- Frontend: C\#, Avalonia
- Local Backend: C\#, Sqlite, #link("https://github.com/Tsinswreng/CsSqlHelper")[CsSqlHelper]
- Server Backend(in progress): C\#, Asp.net, EFCore, PostgreSql

Features:
- client AOT-compatible
- Support Windows, Linux, Android


= Try the app
Prerequisite:
- OS: Windows/Linux
- .NET9 installed

build and run:
+ clone the repo including its sub repo
+ run `./RunWin.sh`



= Word List Markup File

we use Word List Markup File to place the words and their meanings.
suppose when you are reading an article and there are some words you don't know. you can look up the words in online dictionaies and copy the words with its meaning into the word list markup file.
then import the word list file into the app. the app can parse it into word objects and store them in the local database.

== Format

*comments are not allowed*. In order to make convenience for introduction, here we use `#` as line comment mark

#let WordList = read("./WordList.typ")
#raw(WordList)

= Word Weight Algorithm

The app use a weight algorithm to calculate the priority of each word when learning. The main idea is to traverse the leaning records of each words and dynamicly adjust the weight value based on the learning records type (add, remember, forget) and its time.

the app has a built-in weight algorithm.

(in progress) you can also adjust the parameters of existing weight algorithm or define your own weight algorithm. to create custom algorithm, you need to implements the interfaces to make a executable file and specify the path in the app settings. we will call it through command line.

= Word Leaning page

after start, short click the word card represents for remembering the word, long click for forgetting the word. click again is for undo. after each rotate of leaning, click save to save your new leaning records in the database and fresh the words weight

= Screenshots
#image("assets/2025-07-16-15-04-41.png")
#image("assets/2025-07-16-15-07-32.png")

= Server Backend (in progress)
- User Management
- word database remote sync
