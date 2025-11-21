import Foundation

let sampleRecipes: [Recipe] = [
    Recipe(
        id: "spaghetti_carbonara",
        name: "Spaghetti Carbonara",
        image: "spaghetti",
        category: .pasta,
        difficulty: .intermediate,
        baseXP: 120,
        steps: [
            RecipeStep(text: "Boil salted water in a large pot.", duration: 60),
            RecipeStep(text: "Cook spaghetti until al dente, about 8–10 minutes.", duration: 480),
            RecipeStep(text: "Fry chopped bacon until crispy.", duration: 240),
            RecipeStep(text: "Whisk eggs and grated cheese in a bowl.", duration: nil),
            RecipeStep(text: "Toss hot pasta with egg mixture off the heat.", duration: nil),
            RecipeStep(text: "Add bacon, season with black pepper, and serve immediately.", duration: nil)
        ]
    ),
    Recipe(
        id: "garlic_butter_chicken",
        name: "Garlic Butter Chicken",
        image: "chicken",
        category: .chicken,
        difficulty: .intermediate,
        baseXP: 130,
        steps: [
            RecipeStep(text: "Season chicken with salt, pepper, and paprika.", duration: nil),
            RecipeStep(text: "Sear chicken in butter until golden on both sides.", duration: 420),
            RecipeStep(text: "Add minced garlic and cook briefly.", duration: 60),
            RecipeStep(text: "Pour in stock and simmer until chicken is cooked through.", duration: 600),
            RecipeStep(text: "Rest the chicken for a few minutes before slicing.", duration: 180),
            RecipeStep(text: "Garnish with parsley and serve.", duration: nil)
        ]
    ),
    Recipe(
        id: "beef_stir_fry",
        name: "Beef Stir Fry",
        image: "beef",
        category: .beef,
        difficulty: .intermediate,
        baseXP: 110,
        steps: [
            RecipeStep(text: "Slice beef thinly against the grain.", duration: nil),
            RecipeStep(text: "Marinate beef with soy sauce and a little sugar.", duration: 600),
            RecipeStep(text: "Stir-fry vegetables in hot oil.", duration: 300),
            RecipeStep(text: "Add beef and cook quickly over high heat.", duration: 240),
            RecipeStep(text: "Pour in stir-fry sauce and toss to coat.", duration: 60),
            RecipeStep(text: "Serve immediately with steamed rice.", duration: nil)
        ]
    ),
    Recipe(
        id: "pancakes",
        name: "Fluffy Pancakes",
        image: "pancakes",
        category: .breakfast,
        difficulty: .beginner,
        baseXP: 80,
        steps: [
            RecipeStep(text: "Combine flour, sugar, baking powder, and salt.", duration: nil),
            RecipeStep(text: "Whisk milk, egg, and melted butter in another bowl.", duration: nil),
            RecipeStep(text: "Mix wet and dry ingredients until just combined.", duration: nil),
            RecipeStep(text: "Heat a pan and lightly grease it.", duration: 60),
            RecipeStep(text: "Pour batter and cook until bubbles form.", duration: 180),
            RecipeStep(text: "Flip and cook until golden, then serve with syrup.", duration: 120)
        ]
    ),
    Recipe(
        id: "fried_rice",
        name: "Egg Fried Rice",
        image: "fried_rice",
        category: .rice,
        difficulty: .beginner,
        baseXP: 90,
        steps: [
            RecipeStep(text: "Use cold cooked rice for best texture.", duration: nil),
            RecipeStep(text: "Scramble eggs and set aside.", duration: 120),
            RecipeStep(text: "Stir-fry garlic and spring onions.", duration: 120),
            RecipeStep(text: "Add rice and break up any clumps.", duration: 180),
            RecipeStep(text: "Add soy sauce and mix well.", duration: 60),
            RecipeStep(text: "Stir in scrambled eggs and serve hot.", duration: nil)
        ]
    ),
    Recipe(
        id: "tomato_soup",
        name: "Creamy Tomato Soup",
        image: "tomato_soup",
        category: .soup,
        difficulty: .beginner,
        baseXP: 70,
        steps: [
            RecipeStep(text: "Sauté onions and garlic in a pot.", duration: 300),
            RecipeStep(text: "Add chopped tomatoes or canned tomatoes.", duration: nil),
            RecipeStep(text: "Pour in stock and simmer for 15–20 minutes.", duration: 900),
            RecipeStep(text: "Blend until smooth and return to pot.", duration: nil),
            RecipeStep(text: "Stir in cream or milk.", duration: 60),
            RecipeStep(text: "Season and serve with bread.", duration: nil)
        ]
    ),
    Recipe(
        id: "masala_omelette",
        name: "Masala Omelette",
        image: "omelette",
        category: .eggs,
        difficulty: .beginner,
        baseXP: 60,
        steps: [
            RecipeStep(text: "Beat eggs with salt and pepper.", duration: nil),
            RecipeStep(text: "Add chopped onions, chili, and coriander.", duration: nil),
            RecipeStep(text: "Heat oil or butter in a pan.", duration: 60),
            RecipeStep(text: "Pour egg mixture into the pan.", duration: 120),
            RecipeStep(text: "Cook until set, fold, and cook briefly.", duration: 60),
            RecipeStep(text: "Serve hot with toast or roti.", duration: nil)
        ]
    ),
    Recipe(
        id: "grilled_cheese",
        name: "Grilled Cheese Sandwich",
        image: "grilled_cheese",
        category: .sandwich,
        difficulty: .beginner,
        baseXP: 50,
        steps: [
            RecipeStep(text: "Butter one side of each bread slice.", duration: nil),
            RecipeStep(text: "Place cheese between unbuttered sides.", duration: nil),
            RecipeStep(text: "Cook sandwich in a pan, buttered side down.", duration: 180),
            RecipeStep(text: "Press gently and cook until golden.", duration: 120),
            RecipeStep(text: "Flip and cook the other side.", duration: 120),
            RecipeStep(text: "Slice and serve warm.", duration: nil)
        ]
    ),
    Recipe(
        id: "veggie_wrap",
        name: "Veggie Wrap",
        image: "veggie_wrap",
        category: .vegetarian,
        difficulty: .beginner,
        baseXP: 70,
        steps: [
            RecipeStep(text: "Warm the tortilla or wrap.", duration: 60),
            RecipeStep(text: "Spread hummus or sauce on it.", duration: nil),
            RecipeStep(text: "Layer sliced veggies and greens.", duration: nil),
            RecipeStep(text: "Add cheese or protein if desired.", duration: nil),
            RecipeStep(text: "Roll tightly and slice in half.", duration: 60),
            RecipeStep(text: "Serve immediately or pack for later.", duration: nil)
        ]
    ),
    Recipe(
        id: "butter_cake",
        name: "Simple Butter Cake",
        image: "butter_cake",
        category: .dessert,
        difficulty: .advanced,
        baseXP: 150,
        steps: [
            RecipeStep(text: "Preheat oven and grease a cake tin.", duration: 600),
            RecipeStep(text: "Beat butter and sugar until light and fluffy.", duration: 300),
            RecipeStep(text: "Add eggs one at a time, mixing well.", duration: 240),
            RecipeStep(text: "Fold in flour and milk alternately.", duration: nil),
            RecipeStep(text: "Pour batter into tin and smooth the top.", duration: nil),
            RecipeStep(text: "Bake until golden and a skewer comes out clean.", duration: 1800)
        ]
    )
]
