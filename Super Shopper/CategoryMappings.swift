// CategoryMappings.swift

import Foundation

struct CategoryMappings {
    // Store-specific category to main category mappings
    static let mappings: [String: [String: String]] = [
        "Target": targetMapping,
        "Generic Store": genericMapping
        // Add other stores as needed
    ]
    
    // Store-specific subcategory to aisle mappings
    static let aisleMappings: [String: [String: String]] = [
        "Target": targetAisleMapping,
        "Generic Store": genericAisleMapping
        // Add other stores as needed
    ]
    
    // MARK: - ML Model Labels
    // Ensure these labels match exactly with your ML model's output
    static let mlModelLabels: [String] = [
        "Candy & Confectionery", "Dairy", "Snacks", "Produce",
        "Water & Sparkling Water", "Bakery", "Frozen Foods", "Meat & Poultry",
        "Spices & Seasonings", "Coffee & Tea", "Condiments & Sauces",
        "International Foods", "Baking Supplies", "Seafood", "Health & Wellness",
        "Pasta, Rice & Grains", "Canned & Jarred Goods", "Cooking Fats & Oils",
        "Non-Alcoholic Beverages", "Breakfast", "Soda & Soft Drinks", "Desserts",
        "Spreads & Syrups", "Alcoholic Beverages", "Chips & Fries", "Soups & Broths",
        "Juices & Smoothies", "Drink Mixes & Powders", "Prepared Foods",
        "Jerky & Dried Meats", "Protein & Meal Replacements", "Beans & Legumes",
        "Functional Beverages", "Household Cleaning", "Popcorn & Puffed Snacks",
        "Granola & Energy Bars", "Nuts & Seeds", "Pharmacy", "Office Supplies",
        "Vitamins & Supplements", "Baby Products", "Sports & Outdoors",
        "Household Appliances", "Bath & Body", "Furniture", "Pet Supplies",
        "Gardening Supplies"
    ]
    
    // MARK: - Target Mappings
    
    // Subcategory to Main Category Mapping for Target
    static let targetMapping: [String: String] = [
        // Grocery
        "Candy & Confectionery": "Grocery",
        "Dairy": "Grocery",
        "Snacks": "Grocery",
        "Produce": "Grocery",
        "Water & Sparkling Water": "Grocery",
        "Bakery": "Grocery",
        "Frozen Foods": "Grocery",
        "Meat & Poultry": "Grocery",
        "Spices & Seasonings": "Grocery",
        "Coffee & Tea": "Grocery",
        "Condiments & Sauces": "Grocery",
        "International Foods": "Grocery",
        "Baking Supplies": "Grocery",
        "Seafood": "Grocery",
        "Pasta, Rice & Grains": "Grocery",
        "Canned & Jarred Goods": "Grocery",
        "Cooking Fats & Oils": "Grocery",
        "Non-Alcoholic Beverages": "Grocery",
        "Breakfast": "Grocery",
        "Soda & Soft Drinks": "Grocery",
        "Desserts": "Grocery",
        "Spreads & Syrups": "Grocery",
        "Alcoholic Beverages": "Grocery",
        "Chips & Fries": "Grocery",
        "Soups & Broths": "Grocery",
        "Juices & Smoothies": "Grocery",
        "Drink Mixes & Powders": "Grocery",
        "Prepared Foods": "Grocery",
        "Jerky & Dried Meats": "Grocery",
        "Beans & Legumes": "Grocery",
        "Functional Beverages": "Grocery",
        "Popcorn & Puffed Snacks": "Grocery",
        "Granola & Energy Bars": "Grocery",
        "Nuts & Seeds": "Grocery",
        
        // Personal Care
        "Protein & Meal Replacements": "Personal Care",
        "Health & Wellness": "Health or Pharmacy",
        "Pharmacy": "Health or Pharmacy",
        "Vitamins & Supplements": "Health or Pharmacy",
        "Bath & Body": "Personal Care",
        
        // Household Essentials
        "Household Cleaning": "Household Essentials",
        "Household Appliances": "Household Essentials",
        "Furniture": "Furniture",
        "Office Supplies": "School & Office Supplies",
        "Gardening Supplies": "Outdoor Living & Garden",
        
        // Baby
        "Baby Products": "Baby",
        
        // Pets
        "Pet Supplies": "Pets",
        
        // Sports & Outdoors
        "Sports & Outdoors": "Sports & Outdoors",
        
        // Other
        "Other": "Other"
    ]
    
    // Subcategory to Aisle Mapping for Target
    static let targetAisleMapping: [String: String] = [
        // Aisle 1: Fresh Produce
        "Produce": "Aisle 1: Fresh Produce",
        
        // Aisle 2: Dairy Products
        "Dairy": "Aisle 2: Dairy Products",
        
        // Aisle 3: Meats and Seafood
        "Meat & Poultry": "Aisle 3: Meats and Seafood",
        "Seafood": "Aisle 3: Meats and Seafood",
        
        // Aisle 4: Bakery
        "Bakery": "Aisle 4: Bakery",
        "Desserts": "Aisle 4: Bakery",
        
        // Aisle 5: Frozen Foods
        "Frozen Foods": "Aisle 5: Frozen Foods",
        
        // Aisle 6: Beverages
        "Water & Sparkling Water": "Aisle 6: Beverages",
        "Juices & Smoothies": "Aisle 6: Beverages",
        "Soda & Soft Drinks": "Aisle 6: Beverages",
        "Alcoholic Beverages": "Aisle 6: Beverages",
        "Non-Alcoholic Beverages": "Aisle 6: Beverages",
        "Functional Beverages": "Aisle 6: Beverages",
        "Drink Mixes & Powders": "Aisle 6: Beverages",
        
        // Aisle 7: Snacks
        "Snacks": "Aisle 7: Snacks",
        "Candy & Confectionery": "Aisle 7: Snacks",
        "Chips & Fries": "Aisle 7: Snacks",
        "Popcorn & Puffed Snacks": "Aisle 7: Snacks",
        "Granola & Energy Bars": "Aisle 7: Snacks",
        "Nuts & Seeds": "Aisle 7: Snacks",
        "Jerky & Dried Meats": "Aisle 7: Snacks",
        
        // Aisle 8: Breakfast Foods
        "Breakfast": "Aisle 8: Breakfast Foods",
        "Spreads & Syrups": "Aisle 8: Breakfast Foods",
        
        // Aisle 9: Baking Supplies
        "Baking Supplies": "Aisle 9: Baking Supplies",
        "Cooking Fats & Oils": "Aisle 9: Baking Supplies",
        "Spices & Seasonings": "Aisle 9: Baking Supplies",
        
        // Aisle 10: Canned Goods
        "Canned & Jarred Goods": "Aisle 10: Canned Goods",
        "Soups & Broths": "Aisle 10: Canned Goods",
        "Beans & Legumes": "Aisle 10: Canned Goods",
        
        // Aisle 11: Pasta and Rice
        "Pasta, Rice & Grains": "Aisle 11: Pasta and Rice",
        "Condiments & Sauces": "Aisle 11: Pasta and Rice",
        
        // Aisle 12: International Foods
        "International Foods": "Aisle 12: International Foods",
        
        // Aisle 17: Health and Wellness
        "Health & Wellness": "Aisle 17: Health and Wellness",
        "Vitamins & Supplements": "Aisle 17: Health and Wellness",
        "Pharmacy": "Aisle 17: Health and Wellness",
        
        // Aisle 18: Baby Products
        "Baby Products": "Aisle 18: Baby Products",
        
        // Aisle 19: Pet Supplies
        "Pet Supplies": "Aisle 19: Pet Supplies",
        
        // Aisle 20: Household Essentials
        "Household Cleaning": "Aisle 20: Household Essentials",
        "Household Appliances": "Aisle 20: Household Essentials",
        
        // Other
        "Other": "Aisle 30: Other"
    ]
    
    // MARK: - Generic Store Mappings
    
    // Use the same mappings for the Generic Store as a fallback
    static let genericMapping: [String: String] = targetMapping
    static let genericAisleMapping: [String: String] = targetAisleMapping
    
    // MARK: - Emojis for Main Categories
    static let mainCategoryEmojis: [String: String] = [
        "Grocery": "🛒",
        "Personal Care": "🧴",
        "Health or Pharmacy": "💊",
        "Household Essentials": "🏠",
        "Furniture": "🛋️",
        "School & Office Supplies": "✏️",
        "Outdoor Living & Garden": "🌳",
        "Baby": "👶",
        "Pets": "🐶",
        "Sports & Outdoors": "⚽️",
        "Other": "🔖"
    ]
    
    // MARK: - Emojis for Subcategories
    static let subcategoryEmojis: [String: String] = [
        // Grocery
        "Candy & Confectionery": "🍬",
        "Dairy": "🥛",
        "Snacks": "🍿",
        "Produce": "🍎",
        "Water & Sparkling Water": "💧",
        "Bakery": "🥖",
        "Frozen Foods": "🧊",
        "Meat & Poultry": "🍗",
        "Spices & Seasonings": "🧂",
        "Coffee & Tea": "☕️",
        "Condiments & Sauces": "🍯",
        "International Foods": "🍱",
        "Baking Supplies": "🥧",
        "Seafood": "🐟",
        "Pasta, Rice & Grains": "🍚",
        "Canned & Jarred Goods": "🥫",
        "Cooking Fats & Oils": "🧈",
        "Non-Alcoholic Beverages": "🧃",
        "Breakfast": "🥞",
        "Soda & Soft Drinks": "🥤",
        "Desserts": "🍰",
        "Spreads & Syrups": "🍯",
        "Alcoholic Beverages": "🍺",
        "Chips & Fries": "🍟",
        "Soups & Broths": "🥣",
        "Juices & Smoothies": "🍹",
        "Drink Mixes & Powders": "🧋",
        "Prepared Foods": "🍱",
        "Jerky & Dried Meats": "🥓",
        "Beans & Legumes": "🌮",
        "Functional Beverages": "🧃",
        "Popcorn & Puffed Snacks": "🍿",
        "Granola & Energy Bars": "🍫",
        "Nuts & Seeds": "🥜",
        
        // Personal Care
        "Protein & Meal Replacements": "🥤",
        "Health & Wellness": "💊",
        "Pharmacy": "💊",
        "Vitamins & Supplements": "💊",
        "Bath & Body": "🛀",
        
        // Household Essentials
        "Household Cleaning": "🧹",
        "Household Appliances": "🔌",
        "Furniture": "🛋️",
        "Office Supplies": "✏️",
        "Gardening Supplies": "🌱",
        
        // Baby
        "Baby Products": "🍼",
        
        // Pets
        "Pet Supplies": "🐶",
        
        // Sports & Outdoors
        "Sports & Outdoors": "⚽️",
        
        // Other
        "Other": "🔖"
    ]
}
