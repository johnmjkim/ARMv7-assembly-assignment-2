---
title: "COMP2300 Assignment Design Document"
author: John (Min Jae), Kim
email: johnmjkim1216@gmail.com
---

# What : Faceman

My pet is called “Faceman”! It shows facial expressions and players can interact with this pet with several options.

## Menu Selection

Displays `See Pet` option first. The user can use buttons to scroll and select options.

![Figure 1. Menu Selection](assets/menu_selection_image.png)

## <img src="assets/see_pet_icon_image.png" width="60" height="60"> See Pet 

Shows facial expression based on pet's HP and stress.

![Figure 2. See Pet](assets/see_pet_image.png)

## <img src="assets/pet_status_icon_image.png" width="60" height="60"> Pet Status 

Shows pet's HP and stress.

![Figure 3. Pet Status](assets/pet_status_image.png)

## <img src="assets/telepathy_game_icon_image.png" width="60" height="60"> Telepathy Game 

User estimates where the pet wishes to go.

![Figure 4. Telepathy Game](assets/telepathy_game_image.png)

## <img src="assets/feed_pet_icon_image.png" width="60" height="60"> Feed Pet 

User feeds the pet to increase HP if food is available.

![Figure 5. Feed Pet](assets/feed_pet_image.png)

## <img src="assets/sing_to_pet_icon_image.png" width="60" height="60"> Sing to Pet 

User controls the singing mode to the target singing mode. Game ends until the user gets a maximum score. Pet stress decreases to 0 after the game.

![Figure 6. Sing to Pet](assets/sing_to_pet_image.png)

## <img src="assets/exit_icon_image.png" width="60" height="60"> Exit 

Exit to the `See Pet`.

# How : Interaction with Tamagochi 

## Multiple States and Actions

Various libraries with their own special purposes were created to organize which functions and data structures are used for each state.

## Selecting Options in Menu

Pre-defined displays of each option are stored with data structure. Users can navigate these options through buttons A and B which are configured with GPIOTE in `button.S`. The block diagram of states is shown in figure 8.

![Figure 8. Block Diagram](assets/block_diagram_image.png)

## Displaying Facial Expression, Icon and Status bars

Basically, the function `display` is executed in each loop of the `main.S`. In each loop, `display` reads the data of current state in data structure and it would change the pre-defined LED display. The `display` also calls necessary functions from custom-built libraries.

![Figure 9. Displaying](assets/displaying_image.png)

## Updating status periodically

`SysTick_Handler` is used to periodically interrupt and change the data structure of the pet status, food stock. Because the handler can count a maximum of 50 ms (320,000 cycles), data structure is used to repeat 20 times of 50ms cycle to make 1 second. Update status period is also used to trigger status update by 5 seconds.

## Button sound and synthetic music

The `audio.S` library is implemented to create audio from speakers. The main loop constantly adds an increasing number to function `audio_play_sample` to make audio and adds a constant number to mute. Data structure of `button_trigger_sound` is used to control the frequency of the sound. This data structure enables the button to make for the button sound of a few seconds or periodically repeating sounds.

## Random Telepathy, Random Target Music Mode

The random number generator (RNG) module is implemented. The function `generate_random` gets a parameter of inclusive upper bound to calculate a modulus of a generated random number. Once the random module is configured and started, the function can read the random number from the RNG module.

# Why : Reasons for Design and Limitations

## Reasons for Design

Display of the image is done in the main loop because multiple LEDs should be turned on simultaneously. Data structure of predefined image makes the process easier to change the game state and pet status by calling specific functions.

`timer.S` and `buttons.S` implements peripherals to allow a user to interact with the pet. The SysTick handler is used to enable the periodic update of pet status. The period would not be consistent without it.

The button command is sufficiently intuitive to users and easy to catch up what to do. Each button triggers different sounds to notify the user which command has been executed. In a specific state, an unused button is deactivated for simplicity.

## Limitation

`Sing to Pet` can be improved by using a microphone and two independent SysTick handlers.

Instead of buttons, the microphone would record the sound level of the user. The user would gain the score if the sound level is identical to the target sound.

Another independent SysTick handler could have been implemented to evaluate the sound level of the user at the start of the game.