---
title: "Design Proposal"
author: John (Min Jae), Kim
email: johnmjkim1216@gmail.com
---

# What : Life of Circle, Circle of Life

My pet is a 3 x 3 sized circle creature. It periodically requires me to control him to hunt another monster for food. Successfully hunting down the monster increases my pet’s experience. Leveling up makes my pet have a stronger attack point and heal point. If the pet dies during the battle it loses experience and resurrects again.

User’s goal is to raise the pet up to a maximum level of 20. Pet level lower than 5 can only do a simple attack or evasion. Starting from level 10 and 15, pets can choose to learn new skills (poison or fireball). A user wishing to level up faster can also choose an advanced hunting ground which activates from level 10 and 15. 

# How : ARM-v7 Assembly

Interrupt buttons will be used to activate the menu and select options. Interrupt A button activates the menu to see my pet’s status, to hunt or exit and B button to scroll selection. The LED display symbol of each option will show to the user. 

Appropriate audio sound will also be used to notify every user's action (e.g. option selection, hunt and etc) .
