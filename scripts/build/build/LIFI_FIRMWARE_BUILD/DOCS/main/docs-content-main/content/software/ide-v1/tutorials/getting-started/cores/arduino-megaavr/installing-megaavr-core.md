---
title: 'Installing the core for megaAVR boards'
compatible-products: [nano-every, uno-wifi-rev2]
difficulty: beginner
description: 'A step-by-step guide to install the core needed for the UNO WiFi Rev2 and Nano Every boards.'
author: 'Karl Söderby'
---

## Installing megaAVR boards

In this tutorial, we will go through a few simple steps on installing the core for **megaAVR** boards. This installation is necessary to use your board with the offline Arduino IDE.

This tutorial uses the **Arduino IDE**. You can download the editor easily from [our software page](https://www.arduino.cc/en/software).

If you are using the **Cloud Editor**, you can follow the [getting started with the Cloud Editor tutorial](/cloud/web-editor/tutorials/getting-started/getting-started-web-editor).


### Boards using the megaAVR

- Arduino UNO WiFi Rev 2
- Arduino Nano Every

### Downloading and installing

1. First, we need to download the Arduino IDE, which can be done from the [software page](https://www.arduino.cc/en/software).

2. Install the Arduino IDE on your local machine.

3. Open the Arduino IDE.

### Installing the megaAVR core

After we have downloaded, installed and opened the Arduino IDE, let's continue to installing the avrMEGA core.

When we open the editor, we will see an empty sketch.

![An empty Arduino IDE sketch window.](assets/install*megaavr*img01.png)

Here we need to navigate to **Tools > Board > Board Manager**.

![Selecting board manager.](assets/install*megaavr*img02.png)

This will open up a new window, with all available cores. Type in `"megaavr"` in the search field, and install the **Arduino mbed-enabled boards** core.

![List of cores.](assets/install*megaavr*img03.png)

This process may take some time, and you may need to accept the installation window that comes up (depending on your operative system). When it is finished, it should say `"INSTALLED"` under the title.

>**Note:** This process may take several minutes.

Exit the board manager, and go to **Tools > Board > Arduino > Arduino megaAVR Boards**. Here you can see all the Mbed boards listed, where you can select the board you are using. You have now successfully installed the core.

![List of available boards.](assets/install*megaavr*img04.png)

### Selecting the port

Now, let's make sure that our board is found by our computer, by selecting the port. Regardless what kind of program we are uploading to the board, we **always** need to choose the port for the board we are using. This is simply done by navigating to **Tools > Port**, where you select your board from the list.

![Selecting the right board and port.](assets/install*megaavr*img05.png)

This will look different depending on what kind of operative system you are using.

For **Windows** users, it could look like this:

- `<COM15> (Arduino Nano Every)`

For **MAC** users, it could look like this:

- `/dev/cu.usbmodem14112 (Arduino Nano Every)`

### Uploading a simple example

You are now ready to start using your board! The easiest way to check that everything is working, is to upload just a simple blink example to your board. This is done by navigating to **File > Examples > 01.Basics > Blink**.

![Selecting the blink example.](assets/install*megaavr*img06.png)

To upload the sketch, simply click on the arrow in the top left corner. This process takes a few seconds, and it is important to not disconnect the board during this process.

![v](assets/install*megaavr*img07.png)

When the code is uploaded, the text `"Done uploading."` is visible in the bottom left corner.

If you look closely at your board, you will notice an orange LED blink with an interval of one second. This means you have successfully uploaded a program to your board.


