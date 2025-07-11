---
title: 'Arduino Integrated Development Environment (IDE) v1'
description: 'Learn how the Arduino IDE v1 works, such as compiling & uploading sketches, file management, installing dependencies and much more.'
tags: [IDE 1, Editor, Basics]
---


The Arduino Integrated Development Environment - or Arduino Software (IDE) - contains a text editor for writing code, a message area, a text console, a toolbar with buttons for common functions and a series of menus. It connects to the Arduino hardware to upload programs and communicate with them.

## Writing Sketches

Programs written using Arduino Software (IDE) are called **sketches**. These sketches are written in the text editor and are saved with the file extension .ino. The editor has features for cutting/pasting and for searching/replacing text. The message area gives feedback while saving and exporting and also displays errors. The console displays text output by the Arduino Software (IDE), including complete error messages and other information. The bottom righthand corner of the window displays the configured board and serial port. The toolbar buttons allow you to verify and upload programs, create, open, and save sketches, and open the serial monitor.

**NB: Versions of the Arduino Software (IDE) prior to 1.0 saved sketches with the extension .pde. It is possible to open these files with version 1.0, you will be prompted to save the sketch with the .ino extension on save.**

![](assets/IDE*VERIFY*File.jpg)

*Verify*
Checks your code for errors compiling it.

![](assets/IDE*UPLOAD*File.jpg)

*Upload*
Compiles your code and uploads it to the configured board. See [uploading](#uploading) below for details.

Note: If you are using an external programmer with your board, you can hold down the "shift" key on your computer when using this icon. The text will change to "Upload using Programmer"

![](assets/IDE*NEW*File.jpg)

*New*
Creates a new sketch.

![](assets/IDE*OPEN*File.jpg)

*Open*
Presents a menu of all the sketches in your sketchbook. Clicking one will open it within the current window overwriting its content.

Note: due to a bug in Java, this menu doesn't scroll; if you need to open a sketch late in the list, use the **File | Sketchbook** menu instead.

![](assets/IDE*SAVE*File.jpg)

*Save*
Saves your sketch.

![](assets/IDE*SERMON*File.jpg)

*Serial Monitor*
Opens the [serial monitor](#serial-monitor).

Additional commands are found within the five menus: **File**, **Edit**, **Sketch**, **Tools**, **Help**. The menus are context sensitive, which means only those items relevant to the work currently being carried out are available.

### File

- *New*
  Creates a new instance of the editor, with the bare minimum structure of a sketch already in place.

- *Open*
  Allows to load a sketch file browsing through the computer drives and folders.

- *Open Recent*
  Provides a short list of the most recent sketches, ready to be opened.

- *Sketchbook*
  Shows the current sketches within the sketchbook folder structure; clicking on any name opens the corresponding sketch in a new editor instance.

- *Examples*
  Any example provided by the Arduino Software (IDE) or library shows up in this menu item. All the examples are structured in a tree that allows easy access by topic or library.

- *Close*
  Closes the instance of the Arduino Software from which it is clicked.

- *Save*
  Saves the sketch with the current name. If the file hasn't been named before, a name will be provided in a "Save as.." window.

- *Save as...*
  Allows to save the current sketch with a different name.

- *Page Setup*
  It shows the Page Setup window for printing.

- *Print*
  Sends the current sketch to the printer according to the settings defined in Page Setup.

- *Preferences*
  Opens the Preferences window where some settings of the IDE may be customized, as the language of the IDE interface.

- *Quit*
  Closes all IDE windows. The same sketches open when Quit was chosen will be automatically reopened the next time you start the IDE.

### Edit

- *Undo/Redo*
  Goes back of one or more steps you did while editing; when you go back, you may go forward with Redo.

- *Cut*
  Removes the selected text from the editor and places it into the clipboard.

- *Copy*
  Duplicates the selected text in the editor and places it into the clipboard.

- *Copy for Forum*
  Copies the code of your sketch to the clipboard in a form suitable for posting to the forum, complete with syntax coloring.

- *Copy as HTML*
  Copies the code of your sketch to the clipboard as HTML, suitable for embedding in web pages.

- *Paste*
  Puts the contents of the clipboard at the cursor position, in the editor.

- *Select All*
  Selects and highlights the whole content of the editor.

- *Comment/Uncomment*
  Puts or removes the // comment marker at the beginning of each selected line.

- *Increase/Decrease Indent*
  Adds or subtracts a space at the beginning of each selected line, moving the text one space on the right or eliminating a space at the beginning.

- *Find*
  Opens the Find and Replace window where you can specify text to search inside the current sketch according to several options.

- *Find Next*
  Highlights the next occurrence - if any - of the string specified as the search item in the Find window, relative to the cursor position.

- *Find Previous*
  Highlights the previous occurrence - if any - of the string specified as the search item in the Find window relative to the cursor position.

### Sketch

- *Verify/Compile*
  Checks your sketch for errors compiling it; it will report memory usage for code and variables in the console area.

- *Upload*
  Compiles and loads the binary file onto the configured board through the configured Port.

- *Upload Using Programmer*
  This will overwrite the bootloader on the board; you will need to use Tools > Burn Bootloader to restore it and be able to Upload to USB serial port again. However, it allows you to use the full capacity of the Flash memory for your sketch. Please note that this command will NOT burn the fuses. To do so a *Tools -> Burn Bootloader* command must be executed.

- *Export Compiled Binary*
  Saves a .hex file that may be kept as archive or sent to the board using other tools.

- *Show Sketch Folder*
  Opens the current sketch folder.

- *Include Library*
  Adds a library to your sketch by inserting #include statements at the start of your code. For more details, see [libraries](#libraries) below. Additionally, from this menu item you can access the Library Manager and import new libraries from .zip files.

- *Add File...*
  Adds a supplemental file to the sketch (it will be copied from its current location). The file is saved to the `data` subfolder of the sketch, which is intended for assets such as documentation. The contents of the `data` folder are not compiled, so they do not become part of the sketch program.

### Tools

- *Auto Format*
  This formats your code nicely: i.e. indents it so that opening and closing curly braces line up, and that the statements inside curly braces are indented more.

- *Archive Sketch*
  Archives a copy of the current sketch in .zip format. The archive is placed in the same directory as the sketch.

- *Fix Encoding & Reload*
  Fixes possible discrepancies between the editor char map encoding and other operating systems char maps.

- *Serial Monitor*
  Opens the serial monitor window and initiates the exchange of data with any connected board on the currently selected Port. This usually resets the board, if the board supports Reset over serial port opening.

- *Board*
  Select the board that you're using. See below for [descriptions of the various boards](#boards).

- *Port*
  This menu contains all the serial devices (real or virtual) on your machine. It should automatically refresh every time you open the top-level tools menu.

- *Programmer*
  For selecting a hardware programmer when programming a board or chip and not using the onboard USB-serial connection. Normally you won't need this, but if you're [burning a bootloader](/built-in-examples/arduino-isp/ArduinoISP) to a new microcontroller, you will use this.

- *Burn Bootloader*
  The items in this menu allow you to burn a [bootloader](/hacking/software/Bootloader) onto the microcontroller on an Arduino board. This is not required for normal use of an Arduino board but is useful if you purchase a new ATmega microcontroller (which normally come without a bootloader). Ensure that you've selected the correct board from the **Boards** menu before burning the bootloader on the target board. This command also set the right fuses.

### Help

Here you find easy access to a number of documents that come with the Arduino Software (IDE). You have access to Getting Started, Reference, this guide to the IDE and other documents locally, without an internet connection. The documents are a local copy of the online ones and may link back to our online website.

- *Find in Reference*
  This is the only interactive function of the Help menu: it directly selects the relevant page in the local copy of the Reference for the function or command under the cursor.

## Sketchbook

The Arduino Software (IDE) uses the concept of a sketchbook: a standard place to store your programs (or sketches). The sketches in your sketchbook can be opened from the **File > Sketchbook** menu or from the **Open** button on the toolbar. The first time you run the Arduino software, it will automatically create a directory for your sketchbook. You can view or change the location of the sketchbook location from with the **Preferences** dialog.

**Beginning with version 1.0, files are saved with a .ino file extension. Previous versions use the .pde extension. You may still open .pde named files in version 1.0 and later, the software will automatically rename the extension to .ino**.

## Tabs, Multiple Files, and Compilation

Allows you to manage sketches with more than one file (each of which appears in its own tab). These can be normal Arduino code files (no visible extension), C files (.c extension), C++ files (.cpp), or header files (.h).

Before compiling the sketch, all the normal Arduino code files of the sketch (.ino, .pde) are concatenated into a single file following the order the tabs are shown in. The other file types are left as is.

## Uploading

Before uploading your sketch, you need to select the correct items from the **Tools > Board** and **Tools > Port** menus. The [boards](#boards) are described below. On the Mac, the serial port is probably something like **/dev/tty.usbmodem241** (for an UNO or Mega2560 or Leonardo) or **/dev/tty.usbserial-1B1** (for a Duemilanove or earlier USB board), or **/dev/tty.USA19QW1b1P1.1** (for a serial board connected with a Keyspan USB-to-Serial adapter). On Windows, it's probably **COM1** or **COM2** (for a serial board) or **COM4**, **COM5**, **COM7**, or higher (for a USB board) - to find out, you look for USB serial device in the ports section of the Windows Device Manager. On Linux, it should be **/dev/ttyACMx **, **/dev/ttyUSBx** or similar.
Once you've selected the correct serial port and board, press the upload button in the toolbar or select the **Upload** item from the **Sketch** menu. Current Arduino boards will reset automatically and begin the upload. With older boards (pre-Diecimila) that lack auto-reset, you'll need to press the reset button on the board just before starting the upload. On most boards, you'll see the RX and TX LEDs blink as the sketch is uploaded. The Arduino Software (IDE) will display a message when the upload is complete, or show an error.

When you upload a sketch, you're using the Arduino **bootloader**, a small program that has been loaded on to the microcontroller on your board. It allows you to upload code without using any additional hardware. The bootloader is active for a few seconds when the board resets; then it starts whichever sketch was most recently uploaded to the microcontroller. The bootloader will blink the on-board (pin 13) LED when it starts (i.e. when the board resets).

## Libraries

Libraries provide extra functionality for use in sketches, e.g. working with hardware or manipulating data. To use a library in a sketch, select it from the **Sketch > Import Library** menu. This will insert one or more **#include** statements at the top of the sketch and compile the library with your sketch. Because libraries are uploaded to the board with your sketch, they increase the amount of space it takes up. If a sketch no longer needs a library, simply delete its **#include** statements from the top of your code.

There is a [list of libraries](https://www.arduino.cc/reference/en/libraries/) in the reference. Some libraries are included with the Arduino software. Others can be downloaded from a variety of sources or through the Library Manager. Starting with version 1.0.5 of the IDE, you do can import a library from a zip file and use it in an open sketch. See these [instructions for installing a third-party library](/software/ide-v1/tutorials/installing-libraries).

To write your own library, see [this tutorial](/learn/contributions/arduino-creating-library-guide).

## Third-Party Hardware

Support for third-party hardware can be added to the **hardware** directory of your sketchbook directory. Platforms installed there may include board definitions (which appear in the board menu), core libraries, bootloaders, and programmer definitions. To install, create the **hardware** directory, then unzip the third-party platform into its own sub-directory. (Don't use "arduino" as the sub-directory name or you'll override the built-in Arduino platform.) To uninstall, simply delete its directory.

For details on creating packages for third-party hardware, see the [Arduino Platform specification](https://arduino.github.io/arduino-cli/latest/platform-specification/).

## Serial Monitor

This displays serial sent from the Arduino board over USB or serial connector. To send data to the board, enter text and click on the "send" button or press enter. Choose the baud rate from the drop-down menu that matches the rate passed to **Serial.begin** in your sketch. Note that on Windows, Mac or Linux the board will reset (it will rerun your sketch) when you connect with the serial monitor. Please note that the Serial Monitor does not process control characters; if your sketch needs a complete management of the serial communication with control characters, you can use an external terminal program and connect it to the COM port assigned to your Arduino board.

You can also talk to the board from Processing, Flash, MaxMSP, etc (see the [interfacing page](https://playground.arduino.cc/Main/InterfacingWithHardware/) for details).

## Preferences

Some preferences can be set in the preferences dialog (found under the **Arduino** menu on the Mac, or **File** on Windows and Linux). The rest can be found in the preferences file, whose location is shown in the preference dialog.

## Language Support

![](assets/languagePreferences.png)

Since version 1.0.1 , the Arduino Software (IDE) has been translated into 30+ different languages. By default, the IDE loads in the language selected by your operating system. (Note: on Windows and possibly Linux, this is determined by the locale setting which controls currency and date formats, not by the language the operating system is displayed in.)

If you would like to change the language manually, start the Arduino Software (IDE) and open the **Preferences** window. Next to the **Editor Language** there is a dropdown menu of currently supported languages. Select your preferred language from the menu, and restart the software to use the selected language. If your operating system language is not supported, the Arduino Software (IDE) will default to English.

You can return the software to its default setting of selecting its language based on your operating system by selecting **System Default** from the **Editor Language** drop-down. This setting will take effect when you restart the Arduino Software (IDE). Similarly, after changing your operating system's settings, you must restart the Arduino Software (IDE) to update it to the new default language.

## Boards

The board selection has two effects: it sets the parameters (e.g. CPU speed and baud rate) used when compiling and uploading sketches; and sets and the file and fuse settings used by the burn bootloader command. Some of the board definitions differ only in the latter, so even if you've been uploading successfully with a particular selection you'll want to check it before burning the bootloader. You can find different boards [here](https://www.arduino.cc/en/hardware).

Arduino Software (IDE) includes the built in support for the boards in the following list, all based on the AVR Core. The [Boards Manager](/learn/starting-guide/cores) included in the standard installation allows to add support for the growing number of new boards based on different cores like Arduino Due, Arduino Zero, Edison, Galileo and so on.

- *Arduino Yún*
  An ATmega32u4 running at 16 MHz with auto-reset, 12 Analog In, 20 Digital I/O and 7 PWM.

- *Arduino Uno*
  An ATmega328P running at 16 MHz with auto-reset, 6 Analog In, 14 Digital I/O and 6 PWM.

- *Arduino Diecimila or Duemilanove w/ ATmega168*
  An ATmega168 running at 16 MHz with auto-reset.

- *Arduino Nano w/ ATmega328P*
  An ATmega328P running at 16 MHz with auto-reset. Has eight analog inputs.

- *Arduino Mega 2560*
  An ATmega2560 running at 16 MHz with auto-reset, 16 Analog In, 54 Digital I/O and 15 PWM.

- *Arduino Mega*
  An ATmega1280 running at 16 MHz with auto-reset, 16 Analog In, 54 Digital I/O and 15 PWM.

- *Arduino Mega ADK*
  An ATmega2560 running at 16 MHz with auto-reset, 16 Analog In, 54 Digital I/O and 15 PWM.

- *Arduino Leonardo*
  An ATmega32u4 running at 16 MHz with auto-reset, 12 Analog In, 20 Digital I/O and 7 PWM.

- *Arduino Micro*
  An ATmega32u4 running at 16 MHz with auto-reset, 12 Analog In, 20 Digital I/O and 7 PWM.

- *Arduino Esplora*
  An ATmega32u4 running at 16 MHz with auto-reset.

- *Arduino Mini w/ ATmega328P*
  An ATmega328P running at 16 MHz with auto-reset, 8 Analog In, 14 Digital I/O and 6 PWM.

- *Arduino Ethernet*
  Equivalent to Arduino UNO with an Ethernet shield: An ATmega328P running at 16 MHz with auto-reset, 6 Analog In, 14 Digital I/O and 6 PWM.

- *Arduino Fio*
  An ATmega328P running at 8 MHz with auto-reset. Equivalent to Arduino Pro or Pro Mini (3.3V, 8 MHz) w/ ATmega328P, 6 Analog In, 14 Digital I/O and 6 PWM.

- *Arduino BT w/ ATmega328P*
  ATmega328P running at 16 MHz. The bootloader burned (4 KB) includes codes to initialize the on-board Bluetooth® module, 6 Analog In, 14 Digital I/O and 6 PWM..

- *LilyPad Arduino USB*
  An ATmega32u4 running at 8 MHz with auto-reset, 4 Analog In, 9 Digital I/O and 4 PWM.

- *LilyPad Arduino*
  An ATmega168 or ATmega132 running at 8 MHz with auto-reset, 6 Analog In, 14 Digital I/O and 6 PWM.

- *Arduino Pro or Pro Mini (5V, 16 MHz) w/ ATmega328P*
  An ATmega328P running at 16 MHz with auto-reset. Equivalent to Arduino Duemilanove or Nano w/ ATmega328P; 6 Analog In, 14 Digital I/O and 6 PWM.

- *Arduino NG or older w/ ATmega168*
  An ATmega168 running at 16 MHz*without* auto-reset. Compilation and upload is equivalent to Arduino Diecimila or Duemilanove w/ ATmega168, but the bootloader burned has a slower timeout (and blinks the pin 13 LED three times on reset); 6 Analog In, 14 Digital I/O and 6 PWM.

- *Arduino Robot Control*
  An ATmega328P running at 16 MHz with auto-reset.

- *Arduino Robot Motor*
  An ATmega328P running at 16 MHz with auto-reset.

- *Arduino Gemma*
  An ATtiny85 running at 8 MHz with auto-reset, 1 Analog In, 3 Digital I/O and 2 PWM.

For instructions on installing support for other boards, see [third-party hardware](#third-party-hardware) above.
