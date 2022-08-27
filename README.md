
  
  

# AV*labs* AV-KO 1 MK I

  

![badass front shot](https://media.discordapp.net/attachments/712626945023672370/1010155307130949652/unknown.png)

![screenshot of the fusion360 model](https://media.discordapp.net/attachments/712626945023672370/1010184363654262835/unknown.png)

![top view](https://media.discordapp.net/attachments/712626945023672370/1011392259780001873/unknown.png)

  

Welcome to the repository of the AVlabs AV-KO 1 MK I Ortholinear Mechanical Keyboard.

It stemmed from a joke with a friend about those hentai/ahegao keycaps, and lead to become my second keyboard build, after a split redox I finished recently.

I don't really like or understand the QMK Configurator Workflow, So I use KB Layout editor and KBfirmware.com, the latter being EOL/depreciated. Make of that what you will

  

Files made by me are under GPLv3 as always

  
  

# CAD & 3D Printing

  

The body of the AV-KO1 is made to be easily and quickly 3D printed on an average I3 style machine, thanks to it's compact size and simple design. The model has on its left side a small recessed area for a decorative piece with the AVlabs logo on it. A simple extrude operation allow the removal of the aforementioned recessed area if you do not want the AVlabs logo plate : (

Designed in Fusion360, With Models from the community (for the switches and the keycaps, from GrabCAD).  
For some reason, Fusion360 did not let me generate the .f3d file, so the file I'll be releasing are the step files (if for some reason git lfs stops bugging).

I use Eryone Matte PLA filament (available on amazon: https://www.amazon.fr/ERYONE-Filament-1-75mm-Drucker-0-03mm/dp/B08JGPMNQ5?th=1 ) as I really like the matte look of the prints. Print at normal settings, with a higher amount of walls, top/bottom surfaces, and 10% infill. Use normal settings otherwise

A 0.6mm nozzle is nice to avoid long print times

Sliced on PrusaSlicer 2.3.3, printed on heavily modified Ender 3.

![enter image description here](https://media.discordapp.net/attachments/712626945023672370/1010299902091346001/Layer_height_walls_and_top_and_bottom_surfaces.png)

  

For the side decorative plate, you can pretty much do what you want. It's an 11.5 x 45mm rectangle where you can put whatever you want. You can create a component and do its CAM routing, however I did not have aluminium milling bits at the time, so I milled it out of an FR4 Copper Clad instead.

I designed a quick and easy PCB:

![enter image description here](https://cdn.discordapp.com/attachments/712626945023672370/1011019346484674661/unknown.png)

I did the routing in FlatCAM as it's the CAM software I'm the most familiar with for my PCB milling needs. I used a 30° 0.1mm Vee bit for the insulation routing, and a random 3mm carbide bit I found for the drilling and the cutout:

![enter image description here](https://media.discordapp.net/attachments/712626945023672370/1011019221477642422/IMG_20220821_230900.jpg?width=811&height=363)

Looks guuuuuuud! If you want to manufacture this exact board, the gerber files are in the CAD Files folder. (You might have expected a gcode folder, same for the 3D prints? NO. NEVER DOWNLOAD GCODE. DOWNLOAD STLs OR GERBERS AND SLICE THEM/ DO THE CAM YOURSELF. RUNNING INTERNET GCODE WITHOUT PRIOR EVALUATION IS DANGEROUS, AS NO ONE CAN STOP ME FROM MAKING GCODE THAT RUNS FINE SO YOU THINK ITS OKAY BUT MID PRINT MAKES YOUR MACHINE CATCH FIRE. BE SMART. DON'T BE LIKE ME)

  

  

# ELECTRONICS & WIRING

## Why I'm a bad engineer: the excuses

Simplicity and Frugality are the keywords of the AV-KO1. As such, it is a classic handwiring job with 1N4148 diodes for anti-ghosting, row & columns; and has a peticular layout: indeed, even though the keyboard is a 5x14 grid, it is actually 2 5x7 keyboards, for ease of wiring. Yes, this implies the use of an internal (or external) USB hub, yes, this implies 2 different firmwares, and no, I really don't care why it's wrong. It's **my** shitty scrappy keeb.

The MCU (2 of them) I chose was the Arduino Pro Micro. Is it an obsolete, underpowered, suboptimal beginner choice? Yes. Again, I do what I want.

  

## The wiring

Why do we handwire? When (like most people) you don't want to buy expensive PCBs for your keeb, you can, simply wire them by hand! It takes a bit of time, but it is very easy, relaxing, and a great soldering training exercise.

The first "naïve" way to do it would be to simply connect one side of the switch to ground, and the other to the microcontroller:

![enter image description here](https://media.discordapp.net/attachments/712626945023672370/1011021164329566310/unknown.png)

Easy, Right? Well, yeah; it works and all, but it has one limit: if you're building a 9 button macro pad, you need 9 I/O lines. Alright, most modern MCU boards have more than 9 I/O pins. If you're building a 40% Compact keyboard, you need 40 I/O lines. Now, you need a chungus of an MCU with tons of I/O pins, like an Atmel ATMEGA 2560. And if you want to build a 104 key keyboard... you'll need a microcontroller (that doesn't exist to my knowledge) with 100+ I/O lines...

What's the solution then? The most educated/experienced *among us* might say "a shift register! use a shift register!" and while that's very true and elegant solution, in a beginner keyboard build, we now have the overhead of a complicated electronics system, with clock signals, and while very doable, it's a bit of a mess.

Our solution is ***multiplexing***: the art of using clever layouts and clever code to increase our number of inputs. In order to understand, let's check out a schematic I made of my Numpad++ (hehe, see what I did there?) board a while ago:

![enter image description here](https://media.discordapp.net/attachments/712626945023672370/1011024925886255167/unknown.png?width=811&height=465)

  

The main idea is ROWS and COLUMNS. We will need as much pins as our board has rows and columns. In our Case, each half of the keyboard has 35 keys, in a 5 rows x 7 columns fashion. This means that instead of needing 35 I/O pins, we only need 5 + 7 = 12 I/O lines per half.

Think of the rows as __outputs__ and the columns as __inputs__ (from the MCU's point of view). We put the row (the outputs) 0 high, and we scan each column (the inputs) to see which ones are high. If a column is high, we know that for the row 0, the column 3 for instance is high, and we can this way pinpoint exactly which key was pressed in our code. Next, we do the same process with the next rows, and we do it very fast, many times a second.

  

However, we now have another problem: ***ghosting***. Imagine we have the following 3x3 Macropad:

  

![enter image description here](https://media.discordapp.net/attachments/712626945023672370/1011059534233600054/IMG_20220821_233956.jpg?width=811&height=363)

  

Imagine I press the following keys: C, B, and F. Let us run by the process row per row:

- We put R0 to high and scan which columns are high: in our case, C0 and C1. As we are on R0, we know B and C are pressed. Good!

- We now put R0 to low and put R1 to high: here, C0 is high (because we pressed F), but because we pressed B, which is on C1, we now see the E key as pressed: which is wrong!!!

This is called **ghosting**, having unwanted keys seen as pressed. As a solution, we solder a small diode, a 1N4148 for instance, at the output of each switch (so from the switch, to the row). This avoids the "backpowering" that leads to ghosting.

  
  

This is how our 5x7 grid will be laid out (so we'll need two of them):

![enter image description here](https://media.discordapp.net/attachments/712626945023672370/1011280920382292018/unknown.png?width=1440&height=535)

Pretty much just like my example before. I tried designing a PCB for home PCB milling/etching, but turns out that laying out 35 keys, diodes, and a bunch more traces on a single sided copper clad is pretty much impossible... If you went with double sided boards with thin traces, it would be easier, but then you wouldn't really be able to make them at home. (Ignore the fact that the diodes on this schematic are actually LEDs, I used this footprint for convience's sake)

  

## The MCU (The microcontroller, not the Marvel Cinematic Universe)

Why do we go with the Arduino Pro Micro? And not an MCU with more pins like the ATMEGA 2560 like stated above? Well, the Arduino Pro Micro has one little feature we reaaaaaally need: USB HID. What is USB HID? Well, it stands for USB Human Interface Device. Hmm. You're a **human** right? You need a **device** to **interface** with your computer?

That's exactly what HIDs are: keyboard, mice, MIDI devices, etc. And our Arduino Pro Micro has it! How?

If you're already familiar with the Arduino development environment, you know you have to setup the kind of board you use: is it an arduino uno, nano, mega, etc. But... there isn't any "Arduino Pro Micro boards":

![enter image description here](https://media.discordapp.net/attachments/712626945023672370/1011283912246431754/unknown.png)

The answer? Our Arduino Pro Micro is actully just a teeny tiny (but not a Teensy) Arduino Leonardo. The Leonardo is based on a different chip than your average ATMEGA 328p (the one in the Uno and the Nano for instance). It is based on the ATMEGA 32U4, that offers such USB HID compatibility. This is why, even if you're a beginner, you should check out the datasheet of the boards you buy, to see what kind of chip they run. It's interesting stuff.

  

Here are a few pictures of my wiring:

![enter image description here](https://media.discordapp.net/attachments/712626945023672370/1012073111983759440/IMG_20220824_205637.jpg?width=811&height=363)

  
  





  

# BOM

I know this part is supposed to be called BOM, but don't expect an industry standard csv BOM, I'll just list some amazon links. Note: The amazon links are amazon.fr links, as I am French.

  
 Item | Quantity | Comment | Link | 
|--|--|--|--|
| Arduino Pro Micro | 2| The brains of the operation  |https://www.amazon.fr/KeeYees-ATmega32U4-D%C3%A9veloppement-Leonardo-Bootloader/dp/B07FQJW2KN/ref=sr_1_1?keywords=arduino+pro+micro&qid=1660944921&sr=8-1
| Ahegao Keycaps | 26 | The joke it started with, used for letters |https://www.amazon.fr/gp/product/B08G1TYGXR/ref=ewc_pr_img_2?smid=A21G1C0OA1S7UQ&psc=1
| Mionix Keycaps | 44 | Different set, for French special characters, modifiers and punctuation |https://www.amazon.fr/gp/product/B077YDJYCY/ref=ewc_pr_img_1?smid=A1J8S5BWDCGLO8&psc=1
|Akko CS Ocean Blue|2 sets, 90 switches total|Cheap clicky tactile mechanical switches|https://www.amazon.fr/gp/product/B08XXD3MZ1/ref=ewc_pr_img_3?smid=AJJW1W45HAUSR&psc=1
| 1N4148 Diodes | 70 | For anti-ghosting. Solder one at the end of each key going into the row |https://www.amazon.fr/gp/product/B08FBW24S6/ref=ewc_pr_img_4?smid=A1W6JCMFL0W2EG&psc=1
  
  
  
  
  

# Firmware

2 main folders:

  

- KB Layout: the kblayout editor json export. I made both a split and whole version if somehow you want to have a crack at it. In the "whole keeb" folder, there is both a version with 1u keys and 2u keys for the spacebar and enter

- KB Firmware:

- left: the sources, compiled .hex, and .json kbfirmwarebuilder export for the left half of the keeb

- right: the sources, compiled.hex, and .json kbfirmwarebuilder export for the right half of the keeb

  

As mentioned previously, I don't really like QMK and my workflow relies on EOL/depreciated solutions. Here is how I do it.

  

- Start with the layout: http://www.keyboard-layout-editor.com/#/ . This is purely to generate a "cosmetic" map of your keep, really useful to get ideas of the map, see how it will end up. Go in the "Raw data" tab, and copy paste the whole block of text. It describes how your keys are arranged.

- Go to https://kbfirmware.com/ (WARNING: EOL/DEPRECIATED), and copy the layout from kb layout editor in the "Import from keyboard layout editor .com" text field. Click import, and you should see the shape of your keeb in the editor.

- From there, you do the magic: set the columns and rows correctly, set the pins of the MCU, set your keymaps, the different layers, the macros, the RGB LIGHTING BABEHHH (no RGB in the AV-KO 1 tho). It is QMK based, and as such allows for very powerful features. In my case, the Layer 0 is a basic character layer, and the layer 1 has the function keys, the arrows, some other additional modifiers and calls a bunch of macros I can call later in autohotkey.

- Click on Compile, and boom. You've got the firmware file of your keeb.

- I flash it using AVRdudess, but you can use whatever you want. Identify the port your arduino is on, select the AVR109 Bootloader, and the ATmega 32U4 MCU. Select the .hex file you downloaded a minute ago and program! Your keeb should be flashed.

Note: for beginners, flashing firmware on the arduino pro micro might be frustrating. As the pro micro act as a USB HID device, upon power up, it has an 8 second window where you have to reset it in order to be in bootloader mode, so you can upload your code. Past that, and it is just another USB Device.

  
  
  
  

Note 2: debugging..... debugging a keyboard is... surprisingly easy. Most errors will stem from wiring errors (check keys in rows and columns to detect mistakes faster) or keymap booboos. In this case, go back to kb firmware builder, and modify. Don't forget to always download the full zip sources and json layout from kbfirmwarebuilder, and to have some kind of versioning system. Better safe than sorry.  




Note 3: I added a simple AHK script that uses the macro of the left side of the keeb as basic mouse controls. Install autohotkey first, then download and run the ahk script. If you want it to launch on startup, put it in C:\Users\[your username]\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

  
  
  

# Final Build

Building your keeb is actually a pretty fun and relaxing process. Soldering and assembling for hours makes you reach nirvana. Here are a few pics:

First, you should put your switches in the body. Don't press too hard as you might bend or even break your top plate.

Don't put in your keycaps in yet: you might damage them when your board will be on its back on your bench.

  

Now, it's time to wire:

![zae](https://media.discordapp.net/attachments/712626945023672370/1012073111983759440/IMG_20220824_205637.jpg?width=811&height=363)

You can really see the rows of diodes and the columns of wire: I like to do the columns per color, and runing the diodes under. You should refer to my diagram below:

![test](https://media.discordapp.net/attachments/712626945023672370/1012079808550797312/IMG_20220824_212308.jpg?width=811&height=363)

The most important part should be that your wiring and your firmware pinout choices should match.

  

For the rest of the build, check out this amazing hack:

As you know the keeb is 2 seperate keebs: in order to only have one cable sticking out (and a USB C one at that), I've hidden a USB hub in the keyboard: it's a tight fit, and don't forget plenty of electrical tape to avoid shorts:

![test](https://media.discordapp.net/attachments/712626945023672370/1012073111610458213/IMG_20220824_205645.jpg?width=811&height=363)  
Don't close up the case with the bolts before flashing the firmware, ensuring it works and fixing errors! The bolts self tap into the plastic, so it can become fragile after a while. Close it up when you're sure everything is A-OK.  And after all these efforts, we should have a beautiful mechanical keyboard that we built ourselves for a bit less money than a normal high end board! Yours is hackable, QMK based, and better because you built it:  
![enter image description here](https://media.discordapp.net/attachments/712626945023672370/1012391773630382151/IMG_20220825_180232.jpg?width=811&height=363)  
![enter image description here](https://media.discordapp.net/attachments/712626945023672370/1012391773236101120/IMG_20220825_180249.jpg?width=811&height=363)  

Thanks for reading this whole guide. I know it's long, and kinda worthless, but this was my first time documenting a project of mine start to finish: talking about ideas, CAD, 3D printing, CNC milling, electronics, and firmware. Let me know what can be improved!  
Nerdfully yours,  
Av from AVlabs