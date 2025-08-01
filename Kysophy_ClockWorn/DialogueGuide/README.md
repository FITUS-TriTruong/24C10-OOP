Download AssetLib Dialogue Manager 2 or 3. After downloading, you will receive the addon folder. 

![Image15](images/image15.png)

Go to Project -> Project Setting -> Plugins -> Enable Dialogue Manager

To work in Dialogue Manager:

- Click on Dialogue on the bar

![Image12](images/image12.png)

- Click on this to add a new Dialogue

![Image6](images/image6.png)

- Create and save a dialogue



![Image1](images/image1.png)



- Base code. U can delete it 

![Image21](images/image21.png)

Example:

![Image19](images/image19.png)

The – works as same as if statement.

- U can press on this icon to test dialogue

![Image13](images/image13.png)

- Next we need a global script so we can we can access variables for dialogue from the global script

![Image7](images/image7.png)

- Next go to Project -> Project Setting -> Autoload to autoload global.gd. Press add to add

![Image2](images/image2.png)

- Inside global. U can define global variables. For example:

![Image22](images/image22.png)

- After defining, you can use these variables in your dialogue file

![Image16](images/image16.png)

- To make the dialogue run in the game. First: Go to character node add Area 2D as child of the character node, next add a CollisionShape2D as a child of Area 2D node

  ![Image10](images/image10.png)

- Next, press on Node next to the inspector to add signals. Add the body_entered and body_exited of Area2D, signal it to character

![Image8](images/image8.png)

- After that, you will have 2 new function inside character.gd

  ![Image3](images/image3.png)

- Declare a variable to check if the thing you want to talk with inside the range:

![Image20](images/image20.png)

- Change the body_entered and body_exited function of character.gd with that variable to check in/out range

![Image11](images/image11.png)

- Next for the thing you want to talk with(NPC/object), it should also have Area2D and collisionshape2D

![Image5](images/image5.png)

- Inside their script, add the function. The function’s name should be the same as the one you called in body.has_method(…). For example: I called body.has_method(enemy) so I need a func enemy()

![Image23](images/image23.png)



- Next, inside the func _physics_process(delta: float) -> void, we will add some lines of code to check if the thing to want to talk with in range to start the dialogue. The code should have the prototype as this: 

![Image17](images/image17.png)

The circled part is the variable you declared the step before. Input.is_action_.... ( you choose), DialogueManager.show_example_dialogue_balloon(load(“…(the place you save your dialogue), “…”) (the first line inside the dialogue file. For example: ~main, so you fill the blank with main).

- So now you dialogue can work!

- However, in my example dialogue , I have the global variable so to make it work I need to do few more step.

![Image14](images/image14.png)

- Inside the map, I add the item, then add the Area2D and collision_shape2D for it too. For example: I add leaf

![Image9](images/image9.png)

- Next, declare the variable to check if the item you want to interact with in range. For example : var in_leaf_dec = false inside character.gd.

- Next, add body_exited and body_entered of that item into character.gd. Also declare the func character() (or sth else, u can choose the name)

  ![Image4](images/image4.png)

 

- Next you can add some code. In my example, I want to take the leaf then give it to the tree.So inside the func _physics_process(delta: float) -> void: , I add some line of code to check if the leaf is in range to take it, then I set my global variable ( found_tree_item to true)

  ![Image24](images/image24.png)

- Also the leaf should be invisible after pick up, so inside world.gd, I add a function to set it to invisible: 

![Image18](images/image18.png)

That’s all.















































