# `ScenarioCodeParser`

`ScenarioCodeParser` has a feature that takes a scenario code string as input and converts it into a class structure.

## Usage

- **scenario_code** to **class**

```dart
String testScenarioCode = 'test scenario code ...';
RootBlock rootBlock = ScenarioCodeParser(testScenarioCode).parse();
```

- **class** to **scenario_code**

```dart
String generatedScenarioCode = rootBlock.toScenarioCode();
```

## `RootBlock` & `Block` Structure

`RootBlock` has a class structure that contains sub-blocks starting with itself.

```dart
// Example
RootBlock
  - LoopBlock
    - FunctionServiceBlock
    - FunctionServiceBlock
    - IfBlock
      - FunctionServiceBlock
    - ElseBlock  
      - FunctionServiceBlock
  - WaitUntilBlock
  - ValueServiceBlock
  - ...
```

Each `Block` has a `level` attribute to indicate its indentation level.

```dart
// Example
RootBlock                     // level 0 -> Start of scenario code
  - LoopBlock                 // level 1
    - FunctionServiceBlock    // level 2
    - FunctionServiceBlock    // level 2
    - IfBlock                 // level 2
      - FunctionServiceBlock  // level 3
    - ElseBlock               // level 2
      - FunctionServiceBlock  // level 3
  - WaitUntilBlock            // level 1
  - ValueServiceBlock         // level 1
                              // level 0 -> End of scenario code
```

A `Block` has an attribute called `isNestable`, and if this attribute is `true`, the `blocks` member variable will contain other `Blocks`.

```dart
LoopBlock.blocks -> [FunctionServiceBlock, FunctionServiceBlock, IfBlock, ElseBlock]

```

## Input scenario code format

Scenario code must be written in the following format.

1. literal type `double` must have 4 decimal places.
  
        (20.1000)     // valid
        (20.1)        // invalid
  
2. else block must be placed after if block.

        if(...) {
          ...
        }
        else {
          ...
        }

3. else block must placed after new line of if block.

        if(...) {
          ...
        }
        else {        // valid
          ...
        }

        if(...) {
          ...
        } else {     // invalid
          ...
        }

4. space between block name and bracket is not allowed.

        if(...) {    // valid
          ... 
        }

        if (...) {   // invalid
          ...
        }

5. each nestable block line have brackets at the end of the line.

        if(...) {    // valid
          ... 
        }

        if(...) 
        {            // invalid
          ...
        }

6. each `;` token placed at the end of the line, will be ignored.

        wait until(111.1000 MSEC);  // == "wait until(111.1000 MSEC)"

* Example scenario code
        
        loop(1 SEC, (#tag1).value1 > 10 and (#tag1 #tag2).value2 < 20.1000 or (#tag3).value3 == 15) {
          wait until((#tag2).value3 == 15)
          wait until(14 SEC)
          wait until(111.1000 MSEC);
          var1 = (#tag1).service1(100, 23.0000, "string")
          var2 = all(#tag1 #tag2).service1(100, 23.0000)
          (#tag3).service1()
          var3 = (#tag3).service2
          all(#tag3).service1(100, "string")
          if(any(#tag4).value4 == (#tag1).value4) {
            (#tag5).service2()
          }
          else {
            var1 = (#tag8).service3
          }
        }
