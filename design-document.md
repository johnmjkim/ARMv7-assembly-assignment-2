---
title: "COMP2300 Assignment Design Document"
author: John (Min Jae), Kim
email: johnmjkim1216@gmail.com
---

# What : Faceman

My pet is called “Faceman”! It shows facial expressions happy, neutral or sad.  Players can interact with this pet with several options like telepathy game, feeding pet and singing to pet.

## Menu selection

The user can always press button A to exit to see menu options (Exception : telepathy game or singing to a pet). Buttons can be used to scroll and select options.

## See pet

It shows facial expression based on its stress and health point (HP). 

## Pet status

Pet’s stress increases +1 per 5 seconds up to 5. HP decreases -1 per 5 seconds if stress is 5.

## Telepathy game

The user needs to estimate where the pet wishes to go (left or right) in the telepathy game.

## Feed pet

Users can feed the pet to increase HP if food stock is available.

## Sing to pet

User needs to control your singing mode to the target singing mode by using button A and B.

## Exit

Go back to see pet

# How : Interaction with Tamagochi 

## Multiple states and actions

Various libraries with their own special purposes were created to organize which functions and data structure are used for each state.

## Selecting options in menu

Pre-defined displays of each option are stored with data structure. Users can navigate these options through buttons A and B which are configured with GPIOTE in <code>button.S</code>. The block diagram of states is shown in figure X. 

## Displaying facial expression, icon and status bars

Basically, the function <code>display</code> is executed in each loop of the <code>main.S</code>. In each loop, function ‘display’ reads the data of current state in data structure and it would change the pre-defined LED display. The <code>display</code> function also calls necessary functions from custom built libraries.

## Updating status periodically

<code>SysTick_Handler</code> is used to periodically interrupt and change the data structure of the pet status, food stock. Because the handler can count maximum of 50 ms (320,000 cycles), data structure is used to repeat 20 times of 50ms cycle to make 1 second. Update status period is also used to trigger status update by 5 seconds.

## Button sound and synthetic music

The <code>audio.S</code> library is implemented to create audio from speakers. The main loop constantly adds an increasing number to function <code>audio_play_sample</code> to make audio and add constant number to mute. Data structure of <code>button_trigger_sound</code> is used to control frequency of the sound. This data structure enables the button to make for the button sound of a few seconds or periodically repeating sounds.

## Random telepathy, target music mode

The random number generator (RNG) module is implemented. The function <code>generate_random</code> gets a parameter of inclusive upper bound to calculate a modulus of a generated random number. Once the random module is configured and started, the function can read the random number from the address <code>VALUE</code> of the RNG module.

# Why : Reasons for Design and Limitations

## Reasons for Design

## Limitation
