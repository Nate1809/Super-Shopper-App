import Foundation

struct CategoryMappings {
    // Store-specific mappings
    static let mappings: [String: [String: String]] = [
        "Generic Store": genericMapping,
        "Target": targetMapping,
        "Whole Foods": wholeFoodsMapping
        // Add other stores as needed
    ]
    
    // Generic Store Mapping
    static let genericMapping: [String: String] = [
        // Grocery
        "Pasta, Rice & Grains": "Grocery",
        "Spices & Seasonings": "Grocery",
        "Canned & Jarred Goods": "Grocery",
        "International Foods": "Grocery",
        "Beans & Legumes": "Grocery",
        "Baking Supplies": "Grocery",
        "Condiments & Sauces": "Grocery",
        "Cooking Fats & Oils": "Grocery",
        "Soups & Broths": "Grocery",
        "Prepared Foods": "Grocery",
        "Breakfast": "Grocery",
        "Spreads & Syrups": "Grocery",
        // Produce
        "Produce": "Produce",
        // Meat & Seafood
        "Meat & Poultry": "Meat & Seafood",
        "Seafood": "Meat & Seafood",
        // Dairy
        "Dairy": "Dairy",
        // Bakery
        "Bakery": "Bakery",
        "Desserts": "Bakery",
        // Frozen Foods
        "Frozen Foods": "Frozen Foods",
        // Beverages
        "Water & Sparkling Water": "Beverages",
        "Juices & Smoothies": "Beverages",
        "Soda & Soft Drinks": "Beverages",
        "Coffee & Tea": "Beverages",
        "Non-Alcoholic Beverages": "Beverages",
        "Alcoholic Beverages": "Beverages",
        "Functional Beverages": "Beverages",
        "Drink Mixes & Powders": "Beverages",
        // Snacks
        "Snacks": "Snacks",
        "Candy & Confectionery": "Snacks",
        "Chips & Fries": "Snacks",
        "Popcorn & Puffed Snacks": "Snacks",
        "Granola & Energy Bars": "Snacks",
        "Nuts & Seeds": "Snacks",
        "Jerky & Dried Meats": "Snacks",
        // Health & Personal Care
        "Vitamins & Supplements": "Health & Personal Care",
        "Health & Wellness": "Health & Personal Care",
        "Pharmacy": "Health & Personal Care",
        "Bath & Body": "Health & Personal Care",
        "Protein & Meal Replacements": "Health & Personal Care",
        // Household Items
        "Office Supplies": "Household Items",
        "Household Cleaning": "Household Items",
        "Household Appliances": "Household Items",
        "Furniture": "Household Items",
        "Gardening Supplies": "Household Items",
        // Baby Products
        "Baby Products": "Baby Products",
        // Pet Supplies
        "Pet Supplies": "Pet Supplies",
        // Other
        "Sports & Outdoors": "Other"
        // If any subsections are not mapped, they will default to "Other"
    ]
    
    // Target Mapping
    static let targetMapping: [String: String] = [
        // Food & Beverages
        "Pasta, Rice & Grains": "Food & Beverages",
        "Spices & Seasonings": "Food & Beverages",
        "Canned & Jarred Goods": "Food & Beverages",
        "International Foods": "Food & Beverages",
        "Beans & Legumes": "Food & Beverages",
        "Baking Supplies": "Food & Beverages",
        "Condiments & Sauces": "Food & Beverages",
        "Cooking Fats & Oils": "Food & Beverages",
        "Soups & Broths": "Food & Beverages",
        "Prepared Foods": "Food & Beverages",
        "Breakfast": "Food & Beverages",
        "Spreads & Syrups": "Food & Beverages",
        "Produce": "Food & Beverages",
        "Meat & Poultry": "Food & Beverages",
        "Seafood": "Food & Beverages",
        "Dairy": "Food & Beverages",
        "Bakery": "Food & Beverages",
        "Desserts": "Food & Beverages",
        "Frozen Foods": "Food & Beverages",
        "Water & Sparkling Water": "Food & Beverages",
        "Juices & Smoothies": "Food & Beverages",
        "Soda & Soft Drinks": "Food & Beverages",
        "Coffee & Tea": "Food & Beverages",
        "Non-Alcoholic Beverages": "Food & Beverages",
        "Alcoholic Beverages": "Food & Beverages",
        "Functional Beverages": "Food & Beverages",
        "Drink Mixes & Powders": "Food & Beverages",
        "Snacks": "Food & Beverages",
        "Candy & Confectionery": "Food & Beverages",
        "Chips & Fries": "Food & Beverages",
        "Popcorn & Puffed Snacks": "Food & Beverages",
        "Granola & Energy Bars": "Food & Beverages",
        "Nuts & Seeds": "Food & Beverages",
        "Jerky & Dried Meats": "Food & Beverages",
        // Health & Personal Care
        "Vitamins & Supplements": "Health & Personal Care",
        "Health & Wellness": "Health & Personal Care",
        "Pharmacy": "Health & Personal Care",
        "Bath & Body": "Health & Personal Care",
        "Protein & Meal Replacements": "Health & Personal Care",
        // Household Essentials
        "Office Supplies": "Household Essentials",
        "Household Cleaning": "Household Essentials",
        "Household Appliances": "Household Essentials",
        "Furniture": "Household Essentials",
        "Gardening Supplies": "Household Essentials",
        // Baby Products
        "Baby Products": "Baby Products",
        // Pet Supplies
        "Pet Supplies": "Pet Supplies",
        // Other
        "Sports & Outdoors": "Other"
        // If any subsections are not mapped, they will default to "Other"
    ]
    
    // Whole Foods Mapping
    static let wholeFoodsMapping: [String: String] = [
        // Produce
        "Produce": "Produce",
        // Meat & Seafood
        "Meat & Poultry": "Meat & Seafood",
        "Seafood": "Meat & Seafood",
        // Dairy
        "Dairy": "Dairy",
        // Bakery
        "Bakery": "Bakery",
        "Desserts": "Bakery",
        // Frozen Foods
        "Frozen Foods": "Frozen Foods",
        // Beverages
        "Water & Sparkling Water": "Beverages",
        "Juices & Smoothies": "Beverages",
        "Soda & Soft Drinks": "Beverages",
        "Coffee & Tea": "Beverages",
        "Non-Alcoholic Beverages": "Beverages",
        "Alcoholic Beverages": "Beverages",
        "Functional Beverages": "Beverages",
        "Drink Mixes & Powders": "Beverages",
        // Snacks
        "Snacks": "Snacks",
        "Candy & Confectionery": "Snacks",
        "Chips & Fries": "Snacks",
        "Popcorn & Puffed Snacks": "Snacks",
        "Granola & Energy Bars": "Snacks",
        "Nuts & Seeds": "Snacks",
        "Jerky & Dried Meats": "Snacks",
        // Grocery
        "Pasta, Rice & Grains": "Grocery",
        "Spices & Seasonings": "Grocery",
        "Canned & Jarred Goods": "Grocery",
        "International Foods": "Grocery",
        "Beans & Legumes": "Grocery",
        "Baking Supplies": "Grocery",
        "Condiments & Sauces": "Grocery",
        "Cooking Fats & Oils": "Grocery",
        "Soups & Broths": "Grocery",
        "Prepared Foods": "Grocery",
        "Breakfast": "Grocery",
        "Spreads & Syrups": "Grocery",
        // Health & Personal Care
        "Vitamins & Supplements": "Health & Personal Care",
        "Health & Wellness": "Health & Personal Care",
        "Pharmacy": "Health & Personal Care",
        "Bath & Body": "Health & Personal Care",
        "Protein & Meal Replacements": "Health & Personal Care",
        // Other
        "Office Supplies": "Other",
        "Household Cleaning": "Other",
        "Household Appliances": "Other",
        "Furniture": "Other",
        "Gardening Supplies": "Other",
        "Baby Products": "Other",
        "Pet Supplies": "Other",
        "Sports & Outdoors": "Other"
        // If any subsections are not mapped, they will default to "Other"
    ]
}
