type Book record {|
    readonly string id;
    string name;
    string description;
    int quantityAvailable;
|};

type Order record {|
    string id;
    int quantity;
|};

table<Book> key(id) books = table [
    {id: "b01", name: "Origin",
    description: "A thrilling adventure in Spain where Robert Langdon investigates a groundbreaking scientific discovery.",
    quantityAvailable: 15},
    {id: "b02", name: "Let It Snow",
    description: "Interconnected stories set during a snowstorm on Christmas Eve, exploring love, friendship, and unexpected encounters.",
    quantityAvailable: 2},
    {id: "b03", name: "The Book Thief",
    description: "Set in Nazi Germany, it follows Liesel Meminger's journey of discovering the power of words amidst World War II.",
    quantityAvailable: 4},
    {id: "b04", name: "To Kill a Mockingbird",
    description: "A classic tale in Maycomb, Alabama, exploring racial injustice and moral growth through Scout Finch's eyes.",
    quantityAvailable: 10},
    {id: "b05", name: "Pride and Prejudice",
    description: "A timeless romance in early 19th-century England, delving into love, marriage, and social expectations through Elizabeth Bennet's perspective.",
    quantityAvailable: 5}
];
