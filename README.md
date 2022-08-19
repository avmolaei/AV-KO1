# AV*labs* AV-KO 1 MK I 

Welcome to the repository of the AVlabs AV-KO 1 MK I Ortholinear Mechanical Keyboard.
It stemmed from a joke with a friend about those hentai/ahegao keycaps, and lead to become my second keyboard build, after a split redox I finished recently.
I don't really like or understand the QMK Configurator Workflow, So I use KB Layout editor and KBfirmware.com, the latter being EOL/depreciated. Make of that what you will

Files made by me are under GPLv3 as always


# CAD & 3D Printing	

The body of the AV-KO1 is made to be easily and quickly 3D printed on an average I3 style machine, thanks to it's compact size and simple design. The model has on its left side a small recessed area for a machined aluminium piece with the AVlabs logo on it. A simple extrude operation allow the removal of the aforementionned recessed area if you do not want the AVlabs logo plate : ( 
Design tool: Autodesk Fusion 360  





//TODO: recommended print settings and filaments 

# ELECTRONICS & WIRING 

Simplicity  and Frugality are the keywords of the AV-KO1. As such, it is a classic handwiring job with 1N4148 diodes for anti-ghosting, row & collumns; and has a peticular layout: indeed, even though the keyboard is a 5x14 grid, it is actually 2 5x7 keyboards, for ease of wiring. Yes, this implies the use of an internal (or external) USB hub, yes, this implies 2 different firmwares, and no, I really don't care why it's wrong. It's **my** shitty scrappy keeb.
The MCU (2 of them) I chose was the Arduino Pro Micro. Is it an obsolete, underpowered, beginner choice? Yes. Again, I do what I want.    



//TODO: add pictures and tutorial of wiring 

# BOM
I know this part is supposed to be called BOM, but don't expect an industry standard csv BOM, I'll just list some amazon links. Note: The amazon links are amazon.fr links, as I am French. 

| Item | Quantity | Comment | Link | 
|--|--|--|--|
| Ahegao Keycaps | 26 | The joke it started with, used for letters |https://www.amazon.fr/gp/product/B08G1TYGXR/ref=ewc_pr_img_2?smid=A21G1C0OA1S7UQ&psc=1
| Mionix Keycaps | 21 | Different set, for French special characters, modifiers and punctuation |https://www.amazon.fr/gp/product/B077YDJYCY/ref=ewc_pr_img_1?smid=A1J8S5BWDCGLO8&psc=1
|Akko CS Ocean Blue|2 sets, 90 switches total|Cheap clicky tactile mechanical switches|https://www.amazon.fr/gp/product/B08XXD3MZ1/ref=ewc_pr_img_3?smid=AJJW1W45HAUSR&psc=1
| 1N4148 Diodes | 70 | For anti-ghosting. Solder one at the end of each key going into the row |https://www.amazon.fr/gp/product/B08FBW24S6/ref=ewc_pr_img_4?smid=A1W6JCMFL0W2EG&psc=1





# Firmware
2 main folders: 	

 - KB Layout: the kblayout editor json export. I made both a split and whole version if somehow you want to have a crack at it. In the "whole keeb" folder, there is both a version with 1u keys and 2u keys for the spacebar and enter
 - KB Firmware:   
		 - left: the sources, compiled .hex, and .json kbfirmwarebuilder export for the left half of the keeb  
		 - right: the sources, compiled.hex, and .json kbfirmwarebuilder export for the right half of the keeb  

As mentionned previously, I don't really like QMK and my workflow relies on EOL/depreciated solutions. Here is how I do it. 

 - Start with the layout: http://www.keyboard-layout-editor.com/#/ . This is purely to generate a "cosmetic" map of your keep, really useful to get ideas of the map, see how it will end up. Go in the "Raw data" tab, and copy paste the whole block of text. It describes how your keys are arranged.
 - Go to https://kbfirmware.com/ (WARNING: EOL/DEPRECIATED), and copy the layout from kb layout editor in the "Import from keyboard layout editor .com" text field. Click import, and you should see the shape of your keeb in the editor. 
 - From there, you do the magic: set the collumns and rows correctly, set the pins of the MCU, set your keymaps, the different layers, the macros, the RGB LIGHTING BABEHHH. It is QMK based, and as such allows for very powerfull features. In my case, the Layer 0 is a basic character layer, and the layer 1 has the function keys, the arrows, some other additionnal modifiers and calls a bunch of macros I can call later in autohotkey. 
 - Click on Compile, and boom. You've got the firmware file of your keeb. 
 - I flash it using AVRdudess, but you can use whatever you want. Identify the port your arduino is on, select the AVR109 Bootloader, and the ATmega 32U4 MCU. Select the .hex file you downloaded a minute ago and program! Your keeb should be flashed.   
 
Note: for beginners, flashing firmware on the arduino pro might be frustrating. As the pro micro act as a USB HID device, upon power up, it has an 8 second window where you have to reset it in order to be in bootloader mode, so you can upload your code. Past that, and it is just another USB Device.   




Note 2: debugging..... debuggin a keyboard is... surprisingly easy. Most errors will stem from wiring errors (check keys in rows and collumns to detect mistakes faster) or keymap booboos. In this case, go back to kb firmware builder, and modify. Don't forget to always download the full zip sources and json layout from kbfirmwarebuilder, and to have some kind of versionning system. Better safe than sorry. 



# Final Build




//TODO: actually build the keeb, duh
